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
  package "git"
end

