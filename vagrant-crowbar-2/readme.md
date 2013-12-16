Crowbar 2 Development Environment - Vagrant
===========================================

Requires
--------

* Vagrant > 1.4.0
* VirtualBox > 1.4.16
** We are starting work on VMware support.  patches welcome.
* Cygwin (Windows, only, of course)

Vagrant Plugins Required
------------------------

* vagrant-vbguest 0.9.0  (nicely updates your VirtualBox Guest additions)

Synopsis
--------

Crowbar 2 Development Environments Management - Including CentOS, Ubuntu and OpenSUSE

Description
-----------
Vagrant makes it easy to create repeatable development environments by harnessing configuration management principles.

With the addition of "personal.json" you can:
1. Store your secrets without worry of uploading to github by accident
1. Launch many different Linux flavors - whichever suits your development style
1. Tune the development environment to your needs
1. Automatically setup a connection to your test environment
1. Share best-practices and the tools that you love for development. 

Overview
--------

### Networking
Vagrant launches virtual machines by default within the 10.0.2.0/32 NATed network.
Usually 10.0.2.15 and you can access your host box from it on 10.0.2.2  

Connect as the "vagrant" user with simply `vagrant ssh`.

Setup
-----

### Download and install:

* VirtualBox: http://www.virtualbox.org - download and install latest for your environment
  * Run it and go to File:Preferences:Extenions and download the Oracle VM VirtualBox Extentions (otherwise PXE boot wont work)
* Vagrant: http://www.vagrantup.com - download for your platform and install
* vagrant-vbguest plugin: Install it with `vagrant plugin vbguest`

### Proxy:

Building Crowbar downloads a lot from the Internet.  It\'s a best practice to setup a proxy server on your host OS to handle this.  Here's an example squid config file that will work with this setup: http://www.github.com/crowbar/crowbar-utils/vagrant-crowbar-2/squid.conf.sample 

  * Proxy config:  
    * Scenario 1: you run a proxy on your host OS (or have a good upstream proxy)
      *  "proxy_on": "true"
      *  "http_proxy": "http://10.0.2.2:8123"
      *  "https_proxy": "http://10.0.2.2:8123"
    * Scenario 2: you can't be bothered to run a proxy on your host OS
      *  "proxy_on": "false",
 
Configuration
-------------

# 2) Editing the personal.json

  * Go to your crowbar-utils git repo and change directory to `crowbar-utils/vagrant-crowbar-2`
  * Copy `personal.json.example` to `personal.json`
  * Edit the file `personal.json`
    * "guest_hostname" is the hostname of the guest AND machine name that will appear in your hypervizor.
    * "box_name" and "box_url" are pairs: You'll see multiple of these, for reference.  Only one should be uncommented at a time, and they indicate which Linux variant you'll be developing on.  When you change this, change the guest_hostname above to something descriptive and unique to create a new box along side any others.
    * "guest_username" is the username on the guest you'd like to login to the box as.
    * "user_sshpubkey" is the whole line from your host machine users's ~/.ssh/pubkey file, 
      so you can login as "guest_username" without a password.
    * "git_user_name" is a standard git setting - it will show who you are in git-blame
    * "git_user_email" is a standard git setting - how to contact you.
    * "github_id" Github.com is strongly recommended for Crowbar development - and provides a backup location for your stuff, and allows you to interact with the community through Pull Requests.  Accounts are free.
    * "github_password" the most sensitive information here.  For managing your backup repos and pull requests.
    * "github_repo" is our standard crowbar repo.  If you have completely forked Crowbar, put that URL here.
    * "github_extra_remotes" Remotes are added after ./dev setup is complete. To enable,
       remove the # from the attribute name github_extra_remotes. To disable, re-add the #. 
  * Synced folders:
    * recent versions of Vagrant/VirtualBox have no trouble creating the synced folders (yay!)
    * "synced_dir_host": a directory on your host OS that will be shared with the guest.
    * "synced_dir_guest": where you\'d like your host OS\'s synced folder to be mounted.
    * Drop the ISO of the OSes you're planning to build with into the ISO library.
      * In the default config, do the following
        * c:\VMs\VMSharedDir\ (or just /VMs/VMSharedDir/ on Linux) contains: 
           * CentOS-6.2-x86_64-bin-DVD1.iso
           * ubuntu-12.04.2-server-amd64.iso
           * RHEL6.2-20111117.0-Server-x86_64-DVD1.iso  (if you'll be building Hadoop)
    * "crowbar_build_cache": sets the location of the build cache in the default ~/.build-crowbar.conf.  It's our dev-tool's cache to build Crowbar.  The cache cannot (as of now) be on a synced_dir because of issues chrooting to create installation media.
    * "crowbar_iso_library": sets where ISOs for the OSes you're building can be found.  Good to be a synced_dir
    * "crowbar_iso_dest": where you want the dev-tool to deposit completed builds of the Crowbar ISO.  Also best to be a synced_dir.
    * "crowbar_version": 2.  Don't set anything else.
    * "proxy_on": tells Vagrant to setup the guest box to look for a proxy for everything it does - package download, ISO download, github interaction, etc.
    * "http_proxy": pretty obvious.
    * "https_proxy": even more obvious.
    * "guest_cpus": Minimum 3 recommended for building Crowbar
    * "guest_ram": Minimum 3 gigs recommended for building Crowbar
    * "guest_timezone": Welcome to the world!  We try to respect your locale.
    * "guest_extra_packages": ["figlet","fgrep"] A place for you to add package names. 


### Ensure shared ISOs

Crowbar needs Ubuntu and Centos to build all its parts.  Make sure the following ISOs are
in "crowbar_iso_library":
* CentOS-6.2-x86_64-bin-DVD1.iso
* ubuntu-12.04.2-server-amd64.iso
