# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}

#%w{tmux byobu debootstrap git rubygems molly-guard vim vim-rails curl openssl build-essential mkisofs binutils rpm ruby genisoimage}.each do |p|
%w{debootstrap git curl openssl build-essential mkisofs binutils rpm genisoimage erlang ssh}.each do |p|
	package "#{p}" do
		action :install
	end
end


# setup .netrc for github access
template "/home/#{node.props.guest_username}/.netrc" do
	source "netrc.erb"
	mode 0400
	owner node.props.guest_username
	variables ({ 
		:github_id => node.props.github_id,
		:github_password => node.props.github_password
 	})
end

# grab the crowbar repo
execute "git clone crowbar" do
	user node.props.guest_username
	environment my_env
	cwd "/home/#{node.props.guest_username}/"
	command "git clone #{node.props.github_repo}"
	creates "/home/#{node.props.guest_username}/crowbar/"
end

# setup git usernames
template "/home/#{node.props.guest_username}/.gitconfig" do
	source "gitconfig.erb"
	mode 0400
	owner node.props.guest_username
	variables ({ 
		:username => node.props.git_user_name,
		:user_email => node.props.git_user_email
 	})
end

# setup .build-crowbar.conf
template "/home/#{node.props.guest_username}/.build-crowbar.conf" do
	source "buildcrowbarconf.erb"
	mode 0777
	owner node.props.guest_username
	variables ({
		:github_id => node.props.github_id,
		:iso_library => node.props.iso_library,
		:iso_dest => node.props.iso_dest
	})
end

