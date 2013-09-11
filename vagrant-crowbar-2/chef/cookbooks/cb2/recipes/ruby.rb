%w{ruby rubygems}.each do |p|
	package "#{p}" do
		action :install
	end
end


if node.props.crowbar_version == "2" then
  case node[:platform]
  when "ubuntu"
    %w{ruby1.9.1 rubygems1.9.1 ruby1.9.1-dev}.each do |pkg|
      package "#{pkg}"
    end

    execute "/usr/sbin/update-alternatives --set ruby --which one" do
      command "/usr/sbin/update-alternatives --set ruby /usr/bin/ruby1.9.1"
    end

    execute "/usr/sbin/update-alternatives --set gem --which one" do
      command "/usr/sbin/update-alternatives --set gem /usr/bin/gem1.9.1"
    end

  when "suse"
    # wrong, fix.
    pkgs = "ruby1.9.1 rubygems1.9.1"
  end
end
