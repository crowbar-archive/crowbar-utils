
# environment for executes:
node.attribute?('http_proxy') && http_proxy = node.props.http_proxy
node.attribute?('https_proxy') && https_proxy = node.props.https_proxy
my_env = {
	'HOME' => "/home/#{node.props.username}/",
	'http_proxy' => http_proxy,
	'https_proxy' => https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}

execute "check env" do
	command "env > /tmp/env"
	environment my_env
	action :run
end

# create a user on the OS:

user node.props.username do
	action :create	
	home "/home/#{node.props.username}"
	shell "/bin/bash"
	supports :manage_home=>true
	gid "admin" 
end

# give the user some ssh public keys
directory "/home/#{node.props.username}/.ssh" do
	owner node.props.username
	mode "0700"
	action :create
end

execute "add_key" do
	environment my_env
	command "echo \"ssh-rsa #{node.props.user_sshpubkey} #{node.props.user_sshpubkey_host}\" >> /home/#{node.props.username}/.ssh/authorized_keys"
	creates "/home/#{node.props.username}/.ssh/authorized_keys"
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
	template "/home/#{node.props.username}/#{pf}" do
		source "#{pf}.erb"
		mode 0644
		owner node.props.username
		variables ({
			:proxy_host => http_proxy,
			:proxy_ssl_host => https_proxy
		})
	end
end

# append proxy_on.sh to .bashrc
execute "proxy on by default" do
	environment my_env
	command " echo \". ~/proxy_on.sh\n\" >> ~/.bashrc"
	action :run
end

execute "apt-get update" do
	#environment my_env
	command "apt-get update"
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

template "/home/#{node.props.username}/.netrc" do
	source "netrc.erb"
	mode 0400
	owner node.props.username
	variables ({ 
		:github_id => node.props.github_id,
		:github_password => node.props.github_password
 	})
end

execute "git clone crowbar" do
	user node.props.username
	environment my_env
	cwd "/home/#{node.props.username}/"
	command "git clone #{node.props.github_repo}"
	creates "/home/#{node.props.username}/crowbar/"
end

template "/home/#{node.props.username}/.gitconfig" do
	source "gitconfig.erb"
	mode 0400
	owner node.props.username
	variables ({ 
		:username => node.props.username,
		:user_email => node.props.user_email
 	})
end

template "/home/#{node.props.username}/.build-crowbar.conf" do
	source "buildcrowbarconf.erb"
	mode 0777
	owner node.props.username
	variables ({
		:github_id => node.props.github_id,
		:iso_library => node.props.iso_library,
		:iso_dest => node.props.iso_dest
	})
end

execute "dev setup fetch and sync" do
	user node.props.username
	environment my_env
	cwd "/home/#{node.props.username}/crowbar/"
	command "./dev setup; ./dev fetch; ./dev sync "
	action :run
end

# setup timezone
execute "timezone setup" do
	environment my_env
	command "echo \"#{node.props.timezone}\" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
	action :run
end

# install lots of vim stuff:
execute "vim installs pathogen" do
	user node.props.username
	environment my_env
	command "mkdir -p ~/.vim/autoload ~/.vim/bundle; curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	creates "/home/#{node.props.username}/.vim/autoload/pathogen.vim"
	action :run
end

{
	'vim-fugitive' => 'git://github.com/tpope/vim-fugitive.git',
	'nerdtree' => 'https://github.com/scrooloose/nerdtree.git'
}.each_pair do | name, repo |
	execute "vim install #{name}" do
		user node.props.username
		environment my_env
		command "cd ~/.vim/bundle; git clone #{repo}"
		action :run
		creates "/home/#{node.props.username}/.vim/bundle/#{name}"
	end
end

template "/home/#{node.props.username}/.vimrc" do
	source "vimrc"
	mode 0777
	owner "#{node.props.username}"
	variables ({
		:username => node.props.username
	})
end

# grab bits we need

#{  #hash of bits "local" => "remote"
#"#{sharedir}/ISOs/#{distro_iso_name}" => "#{distro_iso_url}",
## add sledgehammer stuff here if necessary
#}.each_pair do |local,remote|
	#remote_file "#{local}" do
		#source "#{remote}"
		#action :nothing
	#end
 #
	#http_request "HEAD #{remote}" do
		#message ""
		#url remote
		#action :head
		#if File.exists?("#{local}")
			#headers "If-Modified-Since" => File.mtime("#{local}").httpdate
		#end
		#notifies :create, resources(:remote_file => "#{local}"), :immediately
	#end
#end
