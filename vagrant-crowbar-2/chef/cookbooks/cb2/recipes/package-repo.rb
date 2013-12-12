case node[:platform]
when "ubuntu"
  # this may not work, because of metadata.
  include_recipe "apt"
when "suse"
  log "need repo setups here"
when "centos"
  #http://dev.centos.org/centos/6/SCL/scl.repo
  cookbook_file "/etc/yum.repos.d/scl.repo" do 
    source "centos_scl.repo" 
    mode 00644 
  end 
  execute "add epel" do
    command "rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
    not_if "yum repolist epel | grep epel"
  end
end
