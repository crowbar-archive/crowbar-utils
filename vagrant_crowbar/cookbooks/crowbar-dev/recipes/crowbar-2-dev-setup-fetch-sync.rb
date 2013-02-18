# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}


# this can take forever - it's setting up the crowbar developemnt environment with ./dev
execute "dev setup" do
	user node.props.guest_username
	environment my_env
	cwd "/home/#{node.props.guest_username}/crowbar/"
	command "./dev setup"
	action :run
	not_if "git config -f /home/#{node.props.guest_username}/crowbar/.git/config --get crowbar.dev.version"	
end

# this can take forever - it's setting up the crowbar developemnt environment with ./dev
%w{fetch sync}.each do |cmd|
	execute "dev #{cmd}" do
		user node.props.guest_username
		environment my_env
		cwd "/home/#{node.props.guest_username}/crowbar/"
		command "./dev #{cmd}"
		action :run
		not_if "git config -f /home/#{node.props.guest_username}/crowbar/.git/config --get crowbar.dev.version"	
	end
end

