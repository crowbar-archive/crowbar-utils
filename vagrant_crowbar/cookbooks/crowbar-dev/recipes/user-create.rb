# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}


group node.props.guest_username do
	action :create
end

# create a group and user on the OS:
user node.props.guest_username do
	action :create	
	home "/home/#{node.props.guest_username}"
	shell "/bin/bash"
	supports :manage_home=>true
	gid node.props.guest_username
end

group "admin" do
	members node.props.guest_username
	append true
end


## give the user some ssh public keys
directory "/home/#{node.props.guest_username}/.ssh" do
	owner node.props.guest_username
	mode "0700"
	action :create
end

execute "add_key" do
	environment my_env
	command "echo \"#{node.props.user_sshpubkey}\" >> /home/#{node.props.guest_username}/.ssh/authorized_keys"
	creates "/home/#{node.props.guest_username}/.ssh/authorized_keys"
	action :run
	not_if "grep \"#{node.props.user_sshpubkey}\" /home/#{node.props.guest_username}/.ssh/authorized_keys "
end	

# setup timezone
execute "timezone setup" do
	environment my_env
	command "echo \"#{node.props.guest_timezone}\" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
	action :run
end
