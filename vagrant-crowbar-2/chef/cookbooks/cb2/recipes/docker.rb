# add deb repo from docker upstream; grab key from keyserver
if node[:platform] == "ubuntu" 

  include_recipe "apt::default"

  apt_repository "docker.org" do
    uri "http://get.docker.io/ubuntu"
    distribution node['lsb']['codename']
    components ["main"]
    key "https://get.docker.io/gpg"
  end

  # now install 
  package "lxc-docker"
end

if node[:platform] == "centos"
  ### docs from http://nareshv.blogspot.com/2013/08/installing-dockerio-on-centos-64-64-bit.html
  ## disable SE linux
  #cat /etc/selinux/config 
  ## This file controls the state of SELinux on the system.
  ## SELINUX= can take one of these three values:
  ##       enforcing - SELinux security policy is enforced.
  ##       permissive - SELinux prints warnings instead of enforcing.
  ##       disabled - SELinux is fully disabled.
  #SELINUX=disabled
  ## SELINUXTYPE= type of policy in use. Possible values are:
  ##       targeted - Only targeted network daemons are protected.
  ##       strict - Full SELinux protection.
  #SELINUXTYPE=targeted

  # install EPEL
  #yum_package "epel for docker" do
  #  http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
  #end

  #cd /etc/yum.repos.d
  #sudo wget http://www.hop5.in/yum/el6/hop5.repo

end
