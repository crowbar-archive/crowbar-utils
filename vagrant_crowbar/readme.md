<pre>
  _|_|_|                                      _|                          
_|       _|  _|_|   _|_|   _|      _|      _| _|_|_|     _|_|_| _|  _|_|  
_|       _|_|     _|    _| _|      _|      _| _|    _| _|    _| _|_|      
_|       _|       _|    _|   _|  _|  _|  _|   _|    _| _|    _| _|        
  _|_|_| _|         _|_|       _|      _|     _|_|_|     _|_|_| _|        
</pre>

vagrant_crowbar - get developing on crowbar quickly
===================================================

This is to setup a dev and build environment for developer/tester use.

This is NOT the an attempt to deploy the Crowbar Admin node through Vagrant.  For that, have a look at https://github.com/crowbar/crowbar-utils/tree/master/test_deploy_utils

Tested OK on hosts:
===================

  * Mac OS Lion, VirtualBox 4.2.6, Vagrant 1.0.5
  * Ubuntu 12.04.2, VirtualBox 4.2.6, Vagrant 1.0.5
  * Windows 7, Virtual Box 4.2.12, Vagrant 1.2.2

NOTE:  Vagrant > 1.2 now supports VMWare: http://www.vagrantup.com/vmware
 

How To:
=======

# Three Steps:
------------

1. Install software requirements
2. Edit personal.json
3. `vagrant up`


# 1) Install Software Requirements:


### 64 Bit
  * You must be running all OSes at *64-bit.*  Host and all guests.  Can't build Crowbar without it.

### Web Proxy
  * It's best practice to have a web proxy running somewhere.  Crowbar downloads a lot of stuff.
    * Host proxy: For greater awesomeness, install a web proxy on your Host box, so you can destroy your
      guest boxes and you won't have to rely entirely on your .crowbar_build_cache.
      * Ubuntu: 
        `apt-get install polipo`
        edit `/etc/polipo/config` to listen on 0.0.0.0 and restart polipo to pick up the changes
        verify with `netstat -lntp | grep polipo`
      * Windows:
        Someone please add here. :)

### Virtual Box
  * Download and install the latest VirtualBox: https://www.virtualbox.org/wiki/Downloads  
  * Do not use stock Ubuntu packages, unless you use the PPA.  They're old.

### Vagrant
  * Download and install the latest Vagrant: http://downloads.vagrantup.com/
  * It does NOT have a GUI.  But once you install it, it's there.
  * Do not use stock Ubuntu packages.  They're old. 
    * Ubuntu:
      Vagrant's Ubuntu packages put vagrant in opt:
      `export PATH=/opt/vagrant/bin/:$PATH`
    * Windows:
      Once installed, you can find Vagrant in c:\HashiCorp\Vagrant\

### Vagrant Plugins
   * Windows: Vagrant plugins are located in: C:\HashiCorp\Vagrant\embedded\gems\gems\vagrant-1.2.2\plugins
   * Auto "VirtualBox Guest Additions" updater for your VMs - GREAT! https://github.com/dotless-de/vagrant-vbguest
      * vagrant plugins add vbguest

### Git - Clone the Repo
  * Install Git on your OS
    * How?  If you're on Microsoft, the Github App is great.  Follow the instructions:
      * https://help.github.com/articles/set-up-git#platform-windows
  * Clone/download this repo: `git clone https://github.com/crowbar/crowbar-utils`
  * You may also use your own group's repo.

## Guest Box URLs
  * These will be important when you're editing your `personal.json`
  * Ubuntu 12.04: https://dl.dropboxusercontent.com/u/9764728/boxes/vagrant-ubuntu12042-64.box
  * OpenSuSE: https://googledrive.com/host/0B6uHJ6DBTZtFcmwyd0dPVVhKcUk/opensuse-12.3-chef.box

### SuSE Guest problems:
  * Setting hostnames doesn't work.  You've gotta do this:
    * https://github.com/dsesh/vagrant/commit/497ebb0f72c2a5dfe211a211348c4149830bff79
    * Ubuntu Host: The file to edit referenced above if found here:
      * /opt/vagrant/...
    * Windows Host: The file to edit referenced above is found here:
      * C:\HashiCorp\Vagrant\embedded\gems\gems\vagrant-1.2.2\plugins\guests\suse\cap\change_host_name.rb

### Windows Host problems:
  * VirtualBox app has to be running, otherwise "vagrant up" will fail with an unhepful message.  `vagrant up`
  * will not start the VirtualBox app for you, like it does in Linux.



# 2) Editing the personal.json

  * Go to your crowbar-utils git repo and change directory to `crowbar-utils/vagrant_crowbar`
  * Copy `personal.json.example` to `personal.json`
  * Edit the file `personal.json`
    * "guest_username" is the username on the guest you'd like to ssh as.
    * "user_sshpubkey" is the whole line from your host machine users's ~/.ssh/pubkey file, 
      so you can login as "guest_username" without a password.
    * Networking:
      * Default networking just works.  NAT is the default, and Vagrant comes up with it's own 
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
    * "rubys_to_install": "1.9.3 1.8.7", note that they're space delimited.

  * Ensure that the shared folders you're planning on using exist on the Host OS.
    * Ensure that your shared folders have open write permissions so the build box can write
      into them. 0777
  * Drop the ISO of the OSes you're planning to build with into the ISO library.

# 3) Make It So

### You should be all ready.  Type: `vagrant up` and watch

  * The box will install and the chef-solo cookbooks will run.
    * Report errors on Github, to IRC (judd7) the crowbar@lists.us.dell.com or find me on skype: juddmaltin-dell  I'm in New York, Eastern Time.
  * Once it's all installed, you can login to the box by running: `vagrant ssh`  
    * OR you can ssh as your user to the IP addresses that you setup in the personal.json file.
  * If you logged in as user `vagrant`, `sudo -i` to root, and then `su - "your username"`
  * You should have ~/crowbar all setup for you!  Switch to a release and branch, and have at it!
    * ./dev switch development/master
    * ./dev build --os ubuntu-12.04 --update-cache

# Typical Development Cycle
=================

### Login

I usually ssh into the box from the host box with the public key I supplied in personal.json.

http://docs.vagrantup.com/v1/docs/getting-started/ssh.html

### Hacking

I'm happy hacking over SSH CLI.  But you can use other things, like installing a GUI 
(`apt-get install kde-desktop`, or `apt-get install xfce`) and interacting via shared desktops. 
That might be great if you run your Vagrant Box on a server.  There are other ways too!

If you need to, you can forward ports from your Vagrant box so they show up on the host box's network:

http://docs.vagrantup.com/v1/docs/getting-started/ports.html

I also really like SSHFS, the FUSE plugin.

### Suspending & Resuming (recommended)

It's best to suspend your system, rather than `vagrant halt` it.  Just type `vagrant suspend` from your host machine in the
Vagrantfile directory, and it'll write memory to disk and quiesce things.  `vagrant resume` does just what you think.

http://docs.vagrantup.com/v1/docs/getting-started/teardown.html

### Restarting (less recommended)

`vagrant halt` will finalize the image and shut it down. To start it up again `vagrant up` will not re-run the 
import BUT IT WILL RE-RUN THE PROVISIONER!  So it's better to use `vagrant suspend` and `vagrant resume.`

### Building

I'm able to use ./dev just fine.  It drops the ISOs in the ISO_LIBRARY directory.

Note that I'm using both a polipo caching web proxy on my client, and one on my host machine.  I try to get
out to the Internet as rarely as possible.


## Troubleshooting

### if a up goes down

If you try vagrant up, and it spits some error out, you'd want to troubleshoot it, by running the provision step on the box itself.
The easiest process is to ssh to the box (see below for windows) and then do what vagrant is trying to do:

cd /tmp/vagrant-chef-1$ 

sudo chef-solo -c solo.rb -j dna.json 

### Running on windows

#### invoking

The vagrant code is written to make accommodations for the windows platform (paths, .exe extensions and such). The thing is that detection only works if you're using the CMD shell (i.e. no cygwin for vagrant).

#### ssh

by default vagrant doesn't even try to use windows ssh, rather spits out some instructions you have to digest. The predigested vesion for cygwin/windows (replace <USERNAME> ) is

$ ssh -vvv vagrant@127.0.0.1 -p 2222 -i /c/Users/<USERNAME>/.vagrant.d/insecure_private_key 




Epilogue
--------

Please let me know what you find: submit bug reports, email me, find me on IRC, or best of all, fork the code and submit pull-requests!

I hope it helps you get up and developing Crowbar quickly.  I look forward to your pull requests.

-judd


