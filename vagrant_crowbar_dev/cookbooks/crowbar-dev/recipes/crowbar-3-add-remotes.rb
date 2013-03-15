# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}



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

