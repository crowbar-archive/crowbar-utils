# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}

bash "sudo json gem install" do
	environment my_env
	user node.props.guest_username
	cwd "/home/#{node.props.guest_username}"
	code <<-EOH
sudo gem install json
EOH
	not_if "gem list json | grep json"
end	
#source $HOME/.rvm/scripts/rvm
#env > /tmp/juddjson
