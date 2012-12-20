username = 'judd'
useremail = 'judd_maltin@dell.com'
user_sshpubkey = ''
user_sshpubkey_host = ''
	
user "#{username}" do
	action :create	
	home "/home/#{username}"
	shell "/bin/bash"
	supports :manage_home=>true
end

directory "/home/#{username}/.ssh" do
	owner "#{username}"
	mode "0700"
	action :create
end

execute "add_key" do
	command "echo \"ssh-rsa #{user_sshpubkey} #{user_sshpubkey_host}\" " >> /home/#{username}/.ssh/authorized_keys"
	creates "/home/#{username}/.ssh/authorized_keys"
	action :run
end	

package "git" do
	action :install
end

git "/home/#{username}/crowbar" do
	repository "https://github.com/dellcloudedge/crowbar.git"
	reference "master"
	action :sync
	user "#{username}"
	group "#{username}"
end

%w{molly-guard vim}.each do |pkg|
	package "#{pkg}" do
		action :install
	end
end

template "/home/#{username}/.gitconfig" do
	source "gitconfig.erb"
	mode 0400
	owner "#{username}"
	group "#{username}"
	variables ({ 
		:user_name => "#{username}",
		:user_email => "#{useremail}"
	})	
end

#beyond this, borken

#template "/home/#{username}/.build-crowbar.conf" do
	#source "build_crowbar.conf.erb"
	#mode 0777
	#owner "#{username}"
	#group "#{username}"
	#variables ({ 
		#:github_id => "juddmaltin-dell #{username}",
		##:iso_library => "/mnt/VMSharedDir",
		##:iso_dest => "/mnt/VMSharedDir/ISOs",
		##:use_proxy => '1',
		##:proxy_host => 'http://127.0.0.1:8123',
	#})	
#end
