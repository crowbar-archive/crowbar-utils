
case node[:platform]
when "ubuntu"
  package "sshfs" do
    action :install
  end
when "centos"
  package "fuse-sshfs" do
    action :install
  end
end

