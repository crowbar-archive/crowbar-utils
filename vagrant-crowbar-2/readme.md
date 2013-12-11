Crowbar 2 Development Environment - Vagrant
===========================================

Requires
--------

* Vagrant > 1.3.0
* VirtualBox > 1.4.16
* Cygwin (Windows, only, of course)

Vagrant Plugins Required
------------------------

* vagrant-vbguest 0.9.0  (nicely updates your VirtualBox Guest additions)


Configuration
-------------

### Copy personal.json.example to personal.json


# 2) Editing the personal.json

  * Go to your crowbar-utils git repo and change directory to `crowbar-utils/vagrant-crowbar-2`
  * Copy `personal.json.example` to `personal.json`
  * Edit the file `personal.json`
    * "guest_username" is the username on the guest you'd like to ssh as.
    * "user_sshpubkey" is the whole line from your host machine users's ~/.ssh/pubkey file, 
      so you can login as "guest_username" without a password.
    * Networking:
      * Default networking just works.  NAT is the default, and Vagrant comes up with its own 
        private IP for your box - usually 10.0.2.15 and you can access your host box from it on 10.0.2.2  
    * Proxy config:  
      * Scenario 1: you run a proxy on your host OS (or have a good upstream proxy)
        *  "proxy_on": "true"
        *  "http_proxy": "http://10.0.2.2:8123"
        *  "https_proxy": "http://10.0.2.2:8123"
      * Scenario 2: you can't be bothered to run a proxy on your host OS
        *  "proxy_on": "false",
    * Choose one of the "box_url"s you'd like to use, and uncomment the "box_name" to match.
    * "github_extra_remotes" Remotes are added after ./dev setup is complete. To enable,
       remove the # from the attribute name github_extra_remotes.  To disable, re-add the #. 
    * "guest_extra_packages": ["figlet","fgrep"] A place for you to add package names. 

  * Synced folders:
    * recent versions of Vagrant/VirtualBox have no trouble creating the synced folders (yay!)
    * Drop the ISO of the OSes you're planning to build with into the ISO library.
      * In the default config, do the following
        * c:\VMs\VMSharedDir\ (or just /VMs/VMSharedDir/ on Linux) contains: 
           * CentOS-6.2-x86_64-bin-DVD1.iso
           * ubuntu-12.04.2-server-amd64.iso
           * RHEL6.2-20111117.0-Server-x86_64-DVD1.iso  (if you'll be building Hadoop)


(see readme.md in vagrant_crowbar directory in this repo)

### Ensure shared ISOs

Crowbar needs Ubuntu and Centos to build all its parts.  Make sure the following ISOs are
in "crowbar_iso_library":
* CentOS-6.2-x86_64-bin-DVD1.iso
* ubuntu-12.04.2-server-amd64.iso
