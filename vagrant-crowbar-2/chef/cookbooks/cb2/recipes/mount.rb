mount "/opt/shared-cache" do
  #mtab:/opt/shared-cache /opt/shared-cache vboxsf uid=1000,gid=1000,rw 0 0
  fstype "vboxsf"
  device "/opt/shared-cache"
  options "rw"
  action [:mount, :enable]
end
  
