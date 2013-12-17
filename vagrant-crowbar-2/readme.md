Crowbar 2 Development Environment - Vagrant
===========================================

Requires
--------

* Vagrant > 1.4.0
* VirtualBox > 1.4.16
  * We are starting work on Vagrant VMware support.  patches welcome.
* Cygwin (Windows, only, of course)


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


Networking
----------

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

Building Crowbar downloads a lot from the Internet.  It's a best practice to setup a proxy server on your host OS to handle this.  Here's an example squid config file that will work with this setup: 

  http://www.github.com/crowbar/crowbar-utils/vagrant-crowbar-2/squid.conf.sample 

 
Configuration
-------------

  * Go to your crowbar-utils git repo and change directory to `crowbar-utils/vagrant-crowbar-2`
  * Copy `personal.json.example` to `personal.json`
  * Edit the file `personal.json`

### `personal.json` Parameters

  * Box Basic Config
    * "guest_hostname" is the hostname of the guest AND machine name that will appear in your hypervizor.
    * "box_name" and "box_url" are pairs: You'll see multiple of these, for reference.  Only one should be uncommented at a time, and they indicate which Linux variant you'll be developing on.  When you change this, change the guest_hostname above to something descriptive and unique to create a new box along side any others.
    * "guest_cpus": Minimum 3 recommended for building Crowbar
    * "guest_ram": Minimum 3 gigs recommended for building Crowbar
    * "guest_timezone": Welcome to the world!  We try to respect your locale.
    * "guest_extra_packages": ["figlet","fgrep"] A place for you to add package names. 
  * User and Repo Config
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
  * Synced folders and Caches:
    * recent versions of Vagrant/VirtualBox have no trouble creating the synced folders (yay!) but they don't support symlinks or chroots (boo!)
    * "synced_dir_host": a directory on your host OS that will be shared with the guest.
    * "synced_dir_guest": where you'd like your host OS's synced folder to be mounted.
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
  * Proxy Config
    * "proxy_on": tells Vagrant to setup the guest box to look for a proxy for everything it does - package download, ISO download, github interaction, etc.
    * "http_proxy": pretty obvious.
    * "https_proxy": even more obvious.


### Ensure shared ISOs

Crowbar needs Ubuntu and Centos to build all its parts.  Make sure the following ISOs are
in "crowbar_iso_library":
* CentOS-6.2-x86_64-bin-DVD1.iso
* ubuntu-12.04.2-server-amd64.iso
* OpenSuse


Running on Windows
------------------

### invoking `vagrant`

The vagrant code is written to make accommodations for the windows platform (paths, .exe extensions and such). The thing is that detection only works if you're using the CMD shell (i.e. no cygwin for vagrant).

### login ssh

By default vagrant doesn't even try to use windows ssh, rather spits out some instructions you have to digest. The predigested vesion for cygwin/windows (replace <USERNAME> ) is

`$ ssh -vvv vagrant@127.0.0.1 -p 2222 -i /c/Users/<USERNAME>/.vagrant.d/insecure_private_key`

Or use your own setup of Putty or what have you that has the private key for the public key you included in the `personal.json`.

Running Vagrant
---------------

### Launching the Box

You should be all ready.  Anywhere within this git repo you should type: 

 `vagrant up`

  * The box OS you will install and the chef-solo cookbooks will run.
  * If there is a problem with the provision stage, you might have to re-run provisioning:

 `vagrant provision`

  * Report errors on Github, to IRC (judd7) the crowbar@lists.us.dell.com or find me on skype: juddmaltin-dell  I'm in New York, Eastern Time.


### Logging into the Box

If the ssh-keys are working OK, you should be able to login this way:

  ssh -p 2222 <username>@127.0.0.1

note that the port may be different if you have another box(es) already running.


Another option is to simply type the following to be logged in as the `vagrant` default user:

 vagrant ssh


  * If you logged in as user `vagrant`, `sudo -i` to root, and then `su - "your username"`
  * You should have ~/crowbar all setup for you!  Switch to a release and branch, and have at it!
    * ./dev switch development/master
    * ./dev build --os ubuntu-12.04 --update-cache

Typical Development/Testing Cycle
==================================

## Developing

### Your Development Environment On The Guest Linux Box

I'm happy hacking over SSH CLI.  But you can use other things, like installing a GUI 
(`apt-get install kde-desktop`, or `apt-get install xfce`) and interacting via shared desktops. 
That might be great if you run your Vagrant Box on a server.  There are other ways too!

### Your Development Environment On the Host (if Linux)

You can use the VirtualBox sync_dir commands to share your directories with the host box.

I also like to use SSHFS to mount directories where I like them.

### Your Development Environment on the Host (if Windows)

Some folks also use SSH or a Samba Mount to access the files.  They then kick off builds on the Linux guest through the command line.

### Other options:

If you need to, you can forward ports from your Vagrant box so they show up on the host box's network:

http://docs.vagrantup.com/v1/docs/getting-started/ports.html

## Building

I'm able to use ./dev just fine.  It drops the ISOs in the ISO_LIBRARY directory.

Note that I'm using both a squid caching web proxy on my host machine.  I try to get out to the Internet as rarely as possible.

## Deploying a test box with your build ISO

If you're using a Linux host, I've created scripts that you run on your host to easily provision your crowbar.iso.  They're in `crowbar-utils/env_setup_scripts/vbox_setup_scripts/`

## Developing on a live Deployed Test box

I mount SSHFS between my development box and my test box.  While editing with Vim, I have it setup to automatically write the files also to the test box, so I can see how I'm affecthing the system.

## Finished for the Day

### Suspending & Resuming (recommended - because it's faster)

It's best to suspend your system, rather than `vagrant halt` it.  Just type `vagrant suspend` from your host machine in the Vagrantfile directory, and it'll write memory to disk and quiesce things.  `vagrant resume` does just what you think.

http://docs.vagrantup.com/v1/docs/getting-started/teardown.html

### Halting and Restarting

`vagrant halt` will finalize the image and shut it down. To start it up again `vagrant up` will not re-run the import nor the provisioner (anymore, as of Vagrant 1.3)


Troubleshooting
===============

### if a up goes down


If you try `vagrant up`, and it spits some error out, you'd want to troubleshoot it.  You can run the provision step again with a simple `vagrant provision.`

If that doesn't give you enought information, try `VAGRANT_LOG=info vagrant provision` and it will give copious output.


Guest Box URLs, for reference
-----------------------------

  * These will be important when you're editing your `personal.json`
  * Ubuntu 12.04: https://dl.dropboxusercontent.com/u/9764728/boxes/vagrant-ubuntu12042-64.box
  * OpenSuSE: https://googledrive.com/host/0B6uHJ6DBTZtFcmwyd0dPVVhKcUk/opensuse-12.3-chef.box
  * CentOS: 


Epilogue
--------

Please let me know what you find: submit bug reports, email me, find me on IRC, or best of all, fork the code and submit pull-requests!

I hope it helps you get up and developing Crowbar quickly.  I look forward to your pull requests.

-judd




