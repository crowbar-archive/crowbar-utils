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

# give guest user superpowers
power_group_name="admin"
case node[:platform]
when "ubuntu"
  power_group_name = "admin"
when "suse"
  power_group_name = "wheel"
end
group "#{power_group_name}" do
  members node.props.guest_username
  append true
end

bash "add NOPASSWD to /etc/sudoers" do
  code "echo \"%#{power_group_name} ALL=NOPASSWD:ALL\" >> /etc/sudoers"
  not_if "grep \"^%#{power_group_name} ALL_NOPASSWD:ALL\" /etc/sudoers"
end

## give the user ssh public keys
directory "/home/#{node.props.guest_username}/.ssh" do
	owner node.props.guest_username
	mode "0700"
	action :create
end

execute "add_key" do
	command "echo \"#{node.props.user_sshpubkey}\" >> /home/#{node.props.guest_username}/.ssh/authorized_keys"
	creates "/home/#{node.props.guest_username}/.ssh/authorized_keys"
	action :run
	not_if "grep \"#{node.props.user_sshpubkey}\" /home/#{node.props.guest_username}/.ssh/authorized_keys "
end	

# setup timezone
execute "timezone setup" do
  case node[:platform]
  when "ubuntu"
    command "echo \"#{node.props.guest_timezone}\" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
  when "suse"
    command "echo \"TZ=#{node.props.guest_timezone}\" >> /home/#{node.props.guest_username}/.profile"
	  not_if "grep \"TZ=#{node.props.guest_timezone}\" /home/#{node.props.guest_username}/.profile"
  end
	action :run
end
