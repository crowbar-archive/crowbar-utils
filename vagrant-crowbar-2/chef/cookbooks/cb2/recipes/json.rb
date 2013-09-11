
gem_package "json" do
  gem_binary "/usr/bin/gem1.9.1"
  options(node.gem_options)
  version ">1"
end


gem_package "kwalify" do
  gem_binary "/usr/bin/gem1.9.1"
  options(node.gem_options)
  version ">0"
end

