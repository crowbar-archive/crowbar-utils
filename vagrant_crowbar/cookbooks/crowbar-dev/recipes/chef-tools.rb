case node[:platform]
when "suse"

  package "rubygem-foodcritic"

  bash "install berkshelf" do
    command "gem install berkshelf -V"
    not_if "gem list berkshelf --local | grep berkshelf"
  end

when "ubuntu"

  bash "install foodcritic" do
    command "gem install foodcritic -V"
    not_if "gem list foodcritic --local | grep berkshelf"
  end

  bash "install berkshelf" do
    command "gem install berkshelf -V"
    not_if "gem list foodcritic --local | grep berkshelf"
  end
  
end

