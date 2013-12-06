
case node[:platform]
when "ubuntu"

    package "sshfs" do
	action :install
    end

end

