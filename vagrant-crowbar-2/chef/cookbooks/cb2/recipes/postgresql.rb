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
    
    # add deb repo from postgresql upstream; grab key from keyserver
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
    bash "Postgresql: add local listener" do
      code "echo 'local	all	all	trust' >> /etc/postgresql/9.3/main/pg_hba.conf; echo 'colic' >> /tmp/test"
      not_if "grep '^local.*trust' /etc/postgresql/9.3/main/pg_hba.conf" 
    end


    #sudo vi /etc/postgresql/9.3/main/postgresql.conf
      # change 'port = 5439'
    bash "Postgresql: change Postgresql port" do
      code 'sed -i "s/port = .*/port = 5439/g" /etc/postgresql/9.3/main/postgresql.conf'
      not_if 'grep "port = 5439" /etc/postgresql/9.3/main/postgresql.conf'
    end

    service "postgresql" do
      action :restart
    end

    #sudo createuser -s -d -U postgres crowbar
    bash "Postgresql: add crowbar user to postgres" do
      code "su postgres -c 'createuser -s -d -U postgres crowbar'"
      not_if 'grep "port = 5439" /etc/postgresql/9.3/main/postgresql.conf'
    end

    # you can test the install by making sure the following call returns
    # you can test the install ONCE CROWBAR IS INSTALLED ON THIS BOX.
    #bash "Postgresql: test postgres install" do
    #  code "su postgres -c PGCLUSTER=9.3/main; psql postgresql://crowbar@:5439/template1 -c 'select true;'"
    #  returns 0
    #end

end
