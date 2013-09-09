execute "gem install json" do
  command "gem install json"
  not_if "gem list json | grep json"
end
