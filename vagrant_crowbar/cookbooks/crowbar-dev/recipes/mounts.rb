#"extra_disk_device": "/mnt/disks/large_disk.vdi",
#"extra_disk_mount": "/mnt/crowbar_cache/",
#"crowbar_cache": "/mnt/crowbar_cache/",
#"shared_dir_guest": "/mnt/VMSharedDir/",
#"shared_dir_host": "/VMs/VMSharedDir/",

mount node.props.extra_disk_mount do
  device "/dev/sdb"
  fstype "ext3"
  action [:mount, :enable]
end

