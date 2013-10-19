# we need Postgresql 9.3 (we rely on 9.3+ features)

case node[:platform]
when "ubuntu"

    # first, remove the automatically added old Posgresql

    #sudo apt-get remove postgresql
    package "sshfs" do
	action :install
    end

end



