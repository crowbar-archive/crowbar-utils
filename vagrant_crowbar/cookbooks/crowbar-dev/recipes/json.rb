envhash = { "http_proxy" => "#{node.props.http_proxy}", 'https_proxy' => "#{node.props.http_proxy}" }

bash "gem install json" do
  environment envhash
	#user node.props.guest_username
	cwd "/home/#{node.props.guest_username}"
	code <<-EOH
gem install json
gem install kwalify
EOH
	not_if "gem list json | grep json"
end	
#source $HOME/.rvm/scripts/rvm
#env > /tmp/juddjson
