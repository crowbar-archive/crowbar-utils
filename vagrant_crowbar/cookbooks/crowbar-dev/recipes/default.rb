
# a shortcut to save typing
p = node.props

Chef::Log.warn(p.username)
# environment for executes:

my_env = {
	#'HOME' => "/home/#{p.username}/",
	'http_proxy' => node['props']['http_proxy'],
	'https_proxy' => node.props.https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}

execute "check env" do
	command "env > /tmp/env"
	environment my_env
	action :run
end

user "#{p.username}" do
	action :create	
	home "/home/#{p.username}"
	shell "/bin/bash"
	supports :manage_home=>true
	gid "admin" 
end

directory "/home/#{p.username}/.ssh" do
	owner "#{p.username}"
	mode "0700"
	action :create
end


execute "add_key" do
	environment my_env
	command "echo \"ssh-rsa #{p.user_sshpubkey} #{p.user_sshpubkey_host}\" >> /home/#{p.username}/.ssh/authorized_keys"
	creates "/home/#{p.username}/.ssh/authorized_keys"
	action :run
end	

#execute "sudo hack" do
	#command "echo \"#{p.username} ALL=(ALL:ALL) NOPASSWD: ALL\" >> /etc/sudoers"
	#action :run
#end

# setup useful http_proxy scripts
%w{proxy_on.sh proxy_off.sh}.each do |pf|
	template "/home/#{p.username}/#{pf}" do
		source "#{pf}.erb"
		mode 0644
		owner p.username
		variables ({
			:proxy_host => p.http_proxy,
			:proxy_ssl_host => p.https_proxy
		})
	end
end

execute "apt-get update" do
	environment my_env
	command "apt-get update"
	action :run
end

%w{git rubygems molly-guard vim vim-rails curl polipo openssl build-essential 
	debootstrap mkisofs binutils rpm ruby genisoimage}.each do |p|
	package "#{p}" do
		action :install
	end
end

execute "json gem" do
	environment my_env
	command "gem install json"
	action :run
end	

template "/home/#{p.username}/.netrc" do
	source "netrc.erb"
	mode 0400
	owner "#{p.username}"
	variables ({ 
		:github_id => p.github_id,
		:github_password => p.github_password
 	})
end

execute "git clone crowbar" do
	user p.username
	environment my_env
	cwd "/home/#{p.username}/"
	command "git clone #{p.github_repo}"
	creates "/home/#{p.username}/crowbar/"
end

template "/home/#{p.username}/.gitconfig" do
	source "gitconfig.erb"
	mode 0400
	owner "#{p.username}"
	variables ({ 
		:username => p.username,
		:user_email => p.user_email
 	})
end

template "/home/#{p.username}/.build-crowbar.conf" do
	source "buildcrowbarconf.erb"
	mode 0777
	owner "#{p.username}"
	variables ({
		:github_id => p.github_id,
		:iso_library => p.iso_library,
		:iso_dest => p.iso_dest
	})
end

execute "dev setup fetch and sync" do
	user p.username
	environment my_env
	cwd "/home/#{p.username}/crowbar/"
	command "./dev setup; ./dev fetch; ./dev sync "
	action :run
end

# setup timezone
execute "timezone setup" do
	environment my_env
	command "echo \"#{timezone}\" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
	action :run
end

# install lots of vim stuff:
execute "vim installs pathogen" do
	user p.username
	environment my_env
	command "mkdir -p ~/.vim/autoload ~/.vim/bundle; curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	creates "/home/#{p.username}/.vim/autoload/pathogen.vim"
	action :run
end

{
	'vim-fugitive' => 'git://github.com/tpope/vim-fugitive.git',
	'nerdtree' => 'https://github.com/scrooloose/nerdtree.git'
}.each_pair do | name, repo |
	execute "vim install #{name}" do
		user p.username
		environment my_env
		command "cd ~/.vim/bundle; git clone #{repo}"
		action :run
		creates "/home/#{p.username}/.vim/bundle/#{name}"
	end
end

template "/home/#{p.username}/.vimrc" do
	source "vimrc"
	mode 0777
	owner "#{p.username}"
	variables ({
		:username => p.username
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
