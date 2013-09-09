case node[:platform]
when "suse"

  package "rubygem-foodcritic"

  execute "install berkshelf" do
    command "gem install berkshelf -V"
    not_if "gem list berkshelf --local | grep berkshelf"
  end

when "ubuntu"

  %w{libxml2 ruby-libxml libxml2-dev libxslt1-dev}.each do |p|
    package "#{p}"
  end

  execute "install foodcritic" do
    command "gem install foodcritic -V"
    not_if "gem list foodcritic --local | grep foodcritic"
  end

  execute "install berkshelf" do
    command "gem install berkshelf -V"
    not_if "gem list berkshelf --local | grep berkshelf"
  end
  
end

