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

package "ruby-rvm" do
	action :install
end

gem_package "json" do
	action :install
end


#execute "json gem" do
	#command "gem install json"
	#environment my_env
	#action :run, :immediately
	#not_if "gem list -i json | grep true"
#end	
