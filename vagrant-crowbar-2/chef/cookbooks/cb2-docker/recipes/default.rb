#
# Cookbook Name:: cb2-docker
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


case node[:platform]
when "ubuntu"
   execute "aloha world!" do
     command "echo 'judd' > /home/vagrant/blah"
   end

#  package "python-software-properties"
#  execute "add PPAs for docker and kernel backport" do
#    command "add-apt-repository -y ppa:dotcloud/lxc-docker; add-apt-repository -y ppa:ubuntu-x-swat/r-lts-backport; apt-get update -qq; apt-get install -q -y linux-image-3.8.0-19-generic lxc-docker; "
#    not_if "uname | grep 3.8"
  #end
end

