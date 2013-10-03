case node[:platform]
when "ubuntu"

	if node.props.crowbar_version == "2" then
		gem_binary_path='/usr/bin/gem1.9.1'
	else
		gem_binary_path='/usr/bin/gem1.8'
	end

	gem_package "json" do
	  gem_binary "#{gem_binary_path}"
	  options(node.gem_options)
	  version ">1"
	end


	gem_package "kwalify" do
	  gem_binary "#{gem_binary_path}"
	  options(node.gem_options)
	  version ">0"
	end

when "suse"
	package "rubygem-json"
	gem_package "kwalify"
end

