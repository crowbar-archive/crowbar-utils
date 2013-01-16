# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}

# need proxy on as soon as possible
## append proxy_on.sh to .bashrc


execute "check env" do
	command "env > /tmp/env"
	environment my_env
	action :run
end


#package "ruby-rvm" do
#	action :install
#end

#gem_package "json" do
	#action :install
#end
 
%w{curl git build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config}.each do |pkg|
	package pkg do
		action :install
	end
end

execute "install rvm" do
	environment my_env
	user node.props.guest_username
	command "curl -L https://get.rvm.io | bash -s stable --trace"
	action :run
	not_if "file /home/#{node.props.guest_username}/.rvm"
end

execute "rvm shell" do
	environment my_env
	user node.props.guest_username
	command "echo \"source $HOME/.rvm/scripts/rvm\" >> ~/.bash_profile"
	action :run
end


node.props.attribute?('rubys_to_install') && node.props.rubys_to_install.split.each do |rubyversion|
	execute "rvm install ruby #{rubyversion}" do
		environment my_env
		user node.props.guest_username
		#command "source $HOME/.rvm/scripts/rvm; command $HOME/.rvm/bin/rvm install #{rubyversion}"
		command "command $HOME/.rvm/bin/rvm install #{rubyversion}"
		action :run
		not_if "rvm list | grep #{rubyversion}"
	end

end

if node.props.attribute?('ruby_default_version') 
	execute "use ruby #{node.props.ruby_default_version}" do
		environment my_env
		user node.props.guest_username
		command "$HOME/.rvm/bin/rvm use #{node.props.ruby_default_version} --default"
		action :run
		#not_if "rvm current | grep #{node.props.ruby_default_version}"
	end
end

#execute "json gem" do
#	command "gem --http-proxy http://127.0.0.1:8123 install json"
##	environment my_env
#	action :run
##	not_if "gem list -i json | grep true"
#end	
