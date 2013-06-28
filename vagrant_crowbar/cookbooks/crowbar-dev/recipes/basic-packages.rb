basic_packages = %w{}

case node[:platform]
when "ubuntu"
  basic_packages = %w{debootstrap git curl openssl build-essential mkisofs binutils rpm genisoimage erlang ssh kvm}
when "suse"
  basic_packages = %w{ca-certificates git curl openssl mkisofs binutils genisoimage kvm}
  execute "zypper ref" do
    command "zypper ref"
    action :run
  end
end

basic_packages.each do |p|
  package "#{p}" do
    action :install
  end
end
