# add deb repo from docker upstream; grab key from keyserver
include_recipe "apt::default"

apt_repository "docker.org" do
  uri "http://get.docker.io/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  key "https://get.docker.io/gpg"
end

# now install 
package "docker-lxc"
