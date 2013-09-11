case node[:platform]
when "ubuntu"
  # this may not work, because of metadata.
  include_recipe "apt"
when "suse"
  log "need repo setups here"
end
