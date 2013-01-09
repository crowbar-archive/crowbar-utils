# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}

# need proxy on as soon as possible
## append proxy_on.sh to .bashrc
execute "proxy on by default" do
	environment my_env
	command " echo \"export http_proxy=\'#{node.props.guest_http_proxy}\'\nexport https_proxy=\'#{node.props.guest_https_proxy}\'\n\" >> /etc/profile"
	action :run
	not_if "grep http_proxy /etc/profile"
end

execute "check env" do
	command "env > /tmp/env"
	environment my_env
	action :run
end

execute "json gem" do
	command "gem install json"
	environment my_env
	action :run
	#not_if "gem list -i json | grep true"
end	

#%w{tmux byobu debootstrap git rubygems molly-guard vim vim-rails curl openssl build-essential mkisofs binutils rpm ruby genisoimage}.each do |p|
%w{debootstrap git rubygems vim vim-rails curl openssl build-essential mkisofs binutils rpm ruby genisoimage erlang ssh}.each do |p|
	package "#{p}" do
		action :upgrade
	end
end



# setup .netrc for github access
template "/home/#{node.props.guest_username}/.netrc" do
	source "netrc.erb"
	mode 0400
	owner node.props.guest_username
	variables ({ 
		:github_id => node.props.github_id,
		:github_password => node.props.github_password
 	})
end

# grab the crowbar repo
execute "git clone crowbar" do
	user node.props.guest_username
	environment my_env
	cwd "/home/#{node.props.guest_username}/"
	command "git clone #{node.props.github_repo}"
	creates "/home/#{node.props.guest_username}/crowbar/"
end

# setup git usernames
template "/home/#{node.props.guest_username}/.gitconfig" do
	source "gitconfig.erb"
	mode 0400
	owner node.props.guest_username
	variables ({ 
		:username => node.props.git_user_name,
		:user_email => node.props.git_user_email
 	})
end

# setup .build-crowbar.conf
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


# this can take forever - it's setting up the crowbar developemnt environment with ./dev
%w{setup fetch sync}.each do |cmd|
	execute "dev #{cmd}" do
		user node.props.guest_username
		environment my_env
		cwd "/home/#{node.props.guest_username}/crowbar/"
		command "./dev #{cmd}"
		action :run
		not_if "git config -f /home/#{node.props.guest_username}/crowbar/.git/config --get crowbar.dev.version"	
	end
end

# add some remotes, if they want it
node.props.attribute?('github_extra_remotes') &&
	node.props[:github_extra_remotes].each do | remote_name, remote_settings |
		execute "set remote #{remote_name} with url #{remote_settings[0]} to priority #{remote_settings[1]}" do
			user node.props.guest_username
			environment my_env
			cwd "/home/#{node.props.guest_username}/crowbar/"
			command "./dev remote add #{remote_name} #{remote_settings[0]}; ./dev remote priority #{remote_name} #{remote_settings[1]};"
			action :run
			not_if "./dev remote show #{remote_name}", 
				:user => node.props.guest_username, 
				:environment => my_env,
				:cwd => "/home/#{node.props.guest_username}/crowbar/"
		end
	end

# setup timezone
execute "timezone setup" do
	environment my_env
	command "echo \"#{node.props.guest_timezone}\" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
	action :run
end

# install extra packages
node.props.attribute?('guest_extra_packages') && node.props.guest_extra_packages.each do | p |
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
