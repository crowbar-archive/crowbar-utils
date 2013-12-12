
log "Adding requirement for testing Crowbar on this box"
case node[:platform] 

when 'ubuntu'
  package "kvm"  
when 'centos'
  #package 'qemu-kvm'
end 
