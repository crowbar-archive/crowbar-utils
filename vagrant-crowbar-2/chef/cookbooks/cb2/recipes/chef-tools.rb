Chef::Log.info("Installing chef tools from gems")

case node[:platform]
when "suse"

  package "rubygem-foodcritic"

  gem_package "berkshelf" do
    options(node.gem_options)
    version ">1"
  end

when "ubuntu"

  %w{libxml2 ruby-libxml libxml2-dev libxslt1-dev}.each do |p|
    package "#{p}"
  end

  gem_package "foodcritic" do
    gem_binary "/usr/bin/gem1.9.1"
    options(node.gem_options)
    version ">1"
  end

  gem_package "berkshelf" do
    gem_binary "/usr/bin/gem1.9.1"
    options(node.gem_options)
    version ">1"
  end

when "centos"
  %w{libxml2-devel libxml2 libxslt-devel}.each do |p|
   package "#{p}"
  end

  %w{foodcritic berkshelf}.each do |pkg|
    execute "install centos scl enable ruby193 \'gem install #{pkg}\'" do
      command "scl enable ruby193 \'gem install #{pkg}\'"
      not_if "scl enable ruby193 \'gem list --local #{pkg} | grep #{pkg}\'"
    end
  end
end

