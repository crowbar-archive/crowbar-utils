# we need Postgresql 9.3 (we rely on 9.3+ features)

case node[:platform]
when "ubuntu"

    # first, remove the automatically added old Posgresql

    #sudo apt-get remove postgresql
    package "postgresql" do
	action :remove
    end

    # Additional reference, please visit [[https://wiki.postgresql.org/wiki/Apt]]

    # for now you need to add the sources (please remove this step when 9.3 is in the official repos!) 
    #deb http://apt.postgresql.org/pub/repos/apt/ [your release]-pgdg main
    #wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
    #sudo apt-get update
    
    # add the Nginx PPA; grab key from keyserver
    include_recipe "apt::default"
    apt_repository "postgresql.org" do
      uri "http://apt.postgresql.org/pub/repos/apt/"
      distribution "#{node['lsb']['codename']}-pgdg"
      components ["main"]
      key "http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc"
    end

    # now install and set to use the special port/pipe config
    #sudo apt-get install postgresql-9.3 pgadmin3
    package "postgresql-9.3" 
    package "pgadmin3" 


    #sudo vi /etc/postgresql/9.3/main/pg_hba.conf
      # add 'local  all   all    trust'
    bash "add local listener" do
      command "sudo echo 'local	all	all	trust' >> /etc/postgresql/9.3/main/pg_hba.conf"
      not_if "grep 'local all' /etc/postgresql/9.3/main/pg_hba.conf" 
    end


    #sudo vi /etc/postgresql/9.3/main/postgresql.conf
      # change 'port = 5439'
    bash "change Postgresql port" do
      command 'sudo sed -i "s/port = .*/port = 5439/g" /etc/postgresql/9.3/main/postgresql.conf'
      not_if 'grep "port = 5439" /etc/postgresql/9.3/main/postgresql.conf'
    end

    #sudo createuser -s -d -U postgres crowbar
    bash "add crowbar user to postgres" do
      command "createuser -s -d -U postgres crowbar"
    end

    # you can test the install by making sure the following call returns
    bash "test postgres isntall" do
      command "PGCLUSTER=9.3/main; psql postgresql://crowbar@:5439/template1 -c 'select true;'"
    end
end



