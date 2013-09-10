# add some remotes, if they want it

node.props.attribute?('github_extra_remotes') &&
node.props[:github_extra_remotes].each do | remote_name, remote_settings |
    log "Adding extra git remote repositories"
		execute "set remote #{remote_name} with url #{remote_settings[0]} to priority #{remote_settings[1]}" do
			user node.props.guest_username
			cwd "/home/#{node.props.guest_username}/crowbar/"
			command "./dev remote add #{remote_name} #{remote_settings[0]}; ./dev remote priority #{remote_name} #{remote_settings[1]};"
			action :run
			not_if "./dev remote show #{remote_name}", 
				:user => node.props.guest_username, 
				:cwd => "/home/#{node.props.guest_username}/crowbar/"
		end
	end

