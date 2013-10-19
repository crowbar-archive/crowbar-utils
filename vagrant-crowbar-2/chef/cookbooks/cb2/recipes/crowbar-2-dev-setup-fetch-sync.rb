
# this can take forever - it's setting up the crowbar developemnt environment with ./dev
envhash = { "LOGNAME" => "#{node.props.guest_username}", 'HOME' => "/home/#{node.props.guest_username}" }

log "Running ./dev setup - really takes forever.  Run top on your VM to make sure it\'s happening."
execute "dev setup" do
  environment envhash
	user node.props.guest_username
	group node.props.guest_username
	cwd "/home/#{node.props.guest_username}/crowbar/"
	command "env > myenv; ./dev setup"
	not_if "git config -f /home/#{node.props.guest_username}/crowbar/.git/config --get crowbar.dev.version"	
end

log "This can take forever - it's setting up the crowbar developemnt environment with ./dev"
%w{fetch sync}.each do |cmd|
  log "Running ./dev #{cmd}"
	execute "dev #{cmd}" do
	  user node.props.guest_username
	  group node.props.guest_username
	  environment envhash
		cwd "/home/#{node.props.guest_username}/crowbar/"
		command "./dev #{cmd}"
		not_if "git config -f /home/#{node.props.guest_username}/crowbar/.git/config --get crowbar.dev.version"	
	end
  log "Finished ./dev #{cmd}"
end
