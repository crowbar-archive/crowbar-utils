# create a group and user on the OS:
group node.props.guest_username do
	action :create
end

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

bash "add NOPASSWD to /etc/sudoers" do
  code "sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers"
end

## give the user some ssh public keys
directory "/home/#{node.props.guest_username}/.ssh" do
	owner node.props.guest_username
	mode "0700"
	action :create
end

execute "add_key" do
	environment node["my_env"]
	command "echo \"#{node.props.user_sshpubkey}\" >> /home/#{node.props.guest_username}/.ssh/authorized_keys"
	creates "/home/#{node.props.guest_username}/.ssh/authorized_keys"
	action :run
	not_if "grep \"#{node.props.user_sshpubkey}\" /home/#{node.props.guest_username}/.ssh/authorized_keys "
end	

# setup timezone
execute "timezone setup" do
	environment node["my_env"]
  case node[:platform]
  when "ubuntu"
    command "echo \"#{node.props.guest_timezone}\" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
  when "suse"
    command "echo \"TZ=#{node.props.guest_timezone}\" >> /home/#{node.props.guest_username}/.profile"
	  not_if "grep \"TZ=#{node.props.guest_timezone}\" /home/#{node.props.guest_username}/.profile"
  end
	action :run
end
