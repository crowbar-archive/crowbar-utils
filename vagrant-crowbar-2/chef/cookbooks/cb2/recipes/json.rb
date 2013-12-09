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

#sudo gem install ruby1.9.3-dev builder bluecloth
#sudo gem install json net-http-digest_auth kwalify bundler delayed_job delayed_job_active_record rake rcov rspec pg --no-ri --no-rdoc
%w{ builder bluecloth net-http-digest_auth kwalify bundler delayed_job delayed_job_active_record rake simplecov rspec pg }.each do | pkg |
	gem_package  "#{pkg}" do
	  gem_binary "#{gem_binary_path}"
	  options(node.gem_options + " --no-ri --no-rdoc ")
	end
end


