
# this can take forever - it's setting up the crowbar developemnt environment with ./dev

execute "dev setup" do
	user node.props.guest_username
	environment node["my_env"]
	cwd "/home/#{node.props.guest_username}/crowbar/"
	command "./dev setup"
	action :run
	not_if "git config -f /home/#{node.props.guest_username}/crowbar/.git/config --get crowbar.dev.version"	
end

# this can take forever - it's setting up the crowbar developemnt environment with ./dev
%w{fetch sync}.each do |cmd|
	execute "dev #{cmd}" do
		user node.props.guest_username
		environment node["my_env"]
		cwd "/home/#{node.props.guest_username}/crowbar/"
		command "./dev #{cmd}"
		action :run
		not_if "git config -f /home/#{node.props.guest_username}/crowbar/.git/config --get crowbar.dev.version"	
	end
end

