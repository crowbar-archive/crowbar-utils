# environment for executes:
my_env = {
	'HOME' => "/home/#{node.props.guest_username}/",
	'http_proxy' => node.props.guest_http_proxy,
	'https_proxy' => node.props.guest_https_proxy,
	'no_proxy' => "127.0.0.0/8,192.168.124.0/24,10.0.0.0/8,143.166.0.0/16"	
}

# install extra packages
node.props.attribute?('guest_extra_packages') && node.props.guest_extra_packages.each do | p |
	package "#{p}" do
		action :upgrade
	end
end

# install lots of vim stuff:
execute "vim installs pathogen" do
	user node.props.guest_username
	environment my_env
	command "mkdir -p ~/.vim/autoload ~/.vim/bundle; curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	creates "/home/#{node.props.guest_username}/.vim/autoload/pathogen.vim"
	action :run
end

{
	'vim-fugitive' => 'git://github.com/tpope/vim-fugitive.git',
	'nerdtree' => 'https://github.com/scrooloose/nerdtree.git'
}.each_pair do | name, repo |
	execute "vim install #{name}" do
		user node.props.guest_username
		environment my_env
		command "cd ~/.vim/bundle; git clone #{repo}"
		action :run
		creates "/home/#{node.props.guest_username}/.vim/bundle/#{name}"
	end
end

template "/home/#{node.props.guest_username}/.vimrc" do
	source "vimrc"
	mode 0777
	owner "#{node.props.guest_username}"
	variables ({
		:username => node.props.guest_username
	})
end
