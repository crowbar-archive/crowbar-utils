username = 'judd'
user_email = 'judd_maltin@dell.com'
user_sshpubkey = ''
user_sshpubkey_host = 'judd-m6600'
github_id = "juddmaltin-dell"
github_password = ""
iso_library = '/mnt/VMSharedDir'
iso_dest = '/mnt/VMSharedDir/ISOs'
use_proxy = '1'
proxy_host = 'http://127.0.0.1:8123'
timezone = 'America/New_York'



user "#{username}" do
	action :create	
	home "/home/#{username}"
	shell "/bin/bash"
	supports :manage_home=>true
	gid "admin" 
end

directory "/home/#{username}/.ssh" do
	owner "#{username}"
	mode "0700"
	action :create
end


execute "add_key" do
	command "echo \"ssh-rsa #{user_sshpubkey} #{user_sshpubkey_host}\" >> /home/#{username}/.ssh/authorized_keys"
	creates "/home/#{username}/.ssh/authorized_keys"
	action :run
end	

#execute "sudo hack" do
	#command "echo \"#{username} ALL=(ALL:ALL) NOPASSWD: ALL\" >> /etc/sudoers"
	#action :run
#end

%w{git rubygems molly-guard vim vim-rails curl polipo}.each do |p|
	package "#{p}" do
		action :install
	end
end

#gem_package 'json' do
#	action :install
#end

execute "json gem" do
	command "gem install json"
	action :run
end	

template "/home/#{username}/.netrc" do
	source "netrc.erb"
	mode 0400
	owner "#{username}"
	group "#{username}"
	variables ({ 
		:github_id => github_id,
		:github_password => github_password
 	})
end

execute "git clone crowbar" do
	user username
	environment ({'HOME' => "/home/#{username}/"})
	cwd "/home/#{username}/"
	command "git clone https://github.com/dellcloudedge/crowbar.git"
	creates "/home/#{username}/crowbar/"
end

template "/home/#{username}/.gitconfig" do
	source "gitconfig.erb"
	mode 0400
	owner "#{username}"
	group "#{username}"
	variables ({ 
		:username => username,
		:user_email => user_email
 	})
end

template "/home/#{username}/.build-crowbar.conf" do
	source "buildcrowbarconf.erb"
	mode 0777
	owner "#{username}"
	group "#{username}"
	variables ({
		:github_id => github_id,
		:iso_library => iso_library,
		:iso_dest => iso_dest,
		:use_proxy => use_proxy,
		:proxy_host => proxy_host
	})
end
#Chef::Log.fatal( 'Something bad happened and I want to stop' )

execute "dev setup fetch and sync" do
	user username
	environment ({'HOME' => "/home/#{username}/"})
	cwd "/home/#{username}/crowbar/"
	command "./dev setup; ./dev fetch; ./dev sync "
	action :run
end


# setup timezone
execute "timezone setup" do
	command "echo \"#{timezone}\" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
	action :run
end


#beyond this, borken

execute "vim installs pathogen" do
	user username
	environment ({'HOME' => "/home/#{username}/"})
	command "mkdir -p ~/.vim/autoload ~/.vim/bundle; curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	creates "/home/#{username}/.vim/autoload/pathogen.vim"
	action :run
end

# install lots of vim stuff:
{
	'vim-fugitive' => 'git://github.com/tpope/vim-fugitive.git',
	'nerdtree' => 'https://github.com/scrooloose/nerdtree.git'
}.each_pair do | name, repo |
	execute "vim install #{name}" do
		user username
		environment ({'HOME' => "/home/#{username}/"})
		command "cd ~/.vim/bundle; git clone #{repo}"
		action :run
		creates "/home/#{username}/.vim/bundle/#{name}"
	end
end

template "/home/#{username}/.vimrc" do
	source "vimrc"
	mode 0777
	owner "#{username}"
	group "#{username}"
	variables ({
		:username => username
	})
end

