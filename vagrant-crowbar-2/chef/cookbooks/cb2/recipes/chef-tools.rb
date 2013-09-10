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
  
end

