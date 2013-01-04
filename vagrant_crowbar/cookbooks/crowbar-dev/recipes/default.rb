# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}

execute "check env" do
	command "env > /tmp/env"
	environment my_env
	action :run
end


group node.props.guest_username do
	action :create
end

# create a group and user on the OS:
user node.props.guest_username do
	action :create	
	home "/home/#{node.props.guest_username}"
	shell "/bin/bash"
	supports :manage_home=>true
	gid "judd" 
end

group "admin" do
  members node.props.guest_username
end


# give the user some ssh public keys
directory "/home/#{node.props.guest_username}/.ssh" do
	owner node.props.guest_username
	mode "0700"
	action :create
end

execute "add_key" do
	environment my_env
	command "echo \"ssh-rsa #{node.props.user_sshpubkey}\" >> /home/#{node.props.guest_username}/.ssh/authorized_keys"
	creates "/home/#{node.props.guest_username}/.ssh/authorized_keys"
	action :run
end	

# I don't need to add him to sudoers, because "admin" group above in Ubuntu 
# gives sudo with NOPASSWD.  ftw
#execute "sudo hack" do
	#command "echo \"#{p.username} ALL=(ALL:ALL) NOPASSWD: ALL\" >> /etc/sudoers"
	#action :run
#end

# setup useful http_proxy scripts
%w{proxy_on.sh proxy_off.sh}.each do |pf|
	template "/home/#{node.props.guest_username}/#{pf}" do
		source "#{pf}.erb"
		mode 0644
		owner node.props.guest_username
		variables ({
			:proxy_host => node.props.guest_http_proxy,
			:proxy_ssl_host => node.props.guest_https_proxy
		})
	end
end

# append proxy_on.sh to .bashrc
execute "proxy on by default" do
	environment my_env
	command " echo \". ~/proxy_on.sh\n\" >> ~/.bashrc"
	action :run
end

%w{tmux byobu debootstrap git rubygems molly-guard vim vim-rails curl polipo openssl build-essential mkisofs binutils rpm ruby genisoimage}.each do |p|
	package "#{p}" do
		action :upgrade
	end
end

execute "json gem" do
	environment my_env
	command "gem install json"
	action :run
end	

template "/home/#{node.props.guest_username}/.netrc" do
	source "netrc.erb"
	mode 0400
	owner node.props.guest_username
	variables ({ 
		:github_id => node.props.github_id,
		:github_password => node.props.github_password
 	})
end

execute "git clone crowbar" do
	user node.props.guest_username
	environment my_env
	cwd "/home/#{node.props.guest_username}/"
	command "git clone #{node.props.github_repo}"
	creates "/home/#{node.props.guest_username}/crowbar/"
end

template "/home/#{node.props.guest_username}/.gitconfig" do
	source "gitconfig.erb"
	mode 0400
	owner node.props.guest_username
	variables ({ 
		:username => node.props.git_user_name,
		:user_email => node.props.git_user_email
 	})
end

template "/home/#{node.props.guest_username}/.build-crowbar.conf" do
	source "buildcrowbarconf.erb"
	mode 0777
	owner node.props.guest_username
	variables ({
		:github_id => node.props.github_id,
		:iso_library => node.props.iso_library,
		:iso_dest => node.props.iso_dest
	})
end

%w{setup fetch sync}.each do |cmd|
	execute "dev #{cmd}" do
		user node.props.guest_username
		environment my_env
		cwd "/home/#{node.props.guest_username}/crowbar/"
		command "./dev #{cmd}"
		action :run
		not_if "git config --get crowbar.dev.version"	
	end
end

# setup timezone
execute "timezone setup" do
	environment my_env
	command "echo \"#{node.props.guest_timezone}\" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
	action :run
end

# install extra packages
node.props.guest_extra_packages.each do | p |
	package "#{p}" do
		action :upgrade
	end
end

# install lots of vim stuff:
execute "vim installs pathogen" do
	user node.props.guest_username
	environment my_env
	command "mkdir -p ~/.vim/autoload ~/.vim/bundle; curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	creates "/home/#{node.props.guest_username}/.vim/autoload/pathogen.vim"
	action :run
end

{
	'vim-fugitive' => 'git://github.com/tpope/vim-fugitive.git',
	'nerdtree' => 'https://github.com/scrooloose/nerdtree.git'
}.each_pair do | name, repo |
	execute "vim install #{name}" do
		user node.props.guest_username
		environment my_env
		command "cd ~/.vim/bundle; git clone #{repo}"
		action :run
		creates "/home/#{node.props.guest_username}/.vim/bundle/#{name}"
	end
end

template "/home/#{node.props.guest_username}/.vimrc" do
	source "vimrc"
	mode 0777
	owner "#{node.props.guest_username}"
	variables ({
		:username => node.props.guest_username
	})
end
