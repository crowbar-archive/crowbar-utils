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
  * Windows 7, Virtual Box 4.2.10, Vagrant 1.1.2
 

How To:
=======

What's You Installation Environment?
------------------------------------

I've created this Vagrantfile, box and cookbooks to support the kind of installation that support your environment.

Proxies are WICKED important - becuase you'll be doing a lot of downloading.

### BEHIND NTLM PROXY
like a typical Corporate Firewall

*personal.json* settings:
  *  "guest_use_cntlm": "true",
  *  "guest_parent_proxy": "127.0.0.1:8123",
  *  "polipo_mode": "work",

### HOST PROXY
you are cool to run a proxy on your host OS (or have a good upstream proxy)

*personal.json* settings:
  *  "guest_use_cntlm": "false",
  *  "guest_parent_proxy: "your parent proxy here",
  *  "polipo_mode": "work"

### NO PROXY (will still install a proxy on the guest)
you can't be bothered to run a proxy on your host OS

*personal.json* settings:
  *  "guest_use_cntlm": "false",
  *  "polipo_mode": "home",


Host Prerequisites:
-------------------

### 64 Bit
  * You must be running all OSes at *64-bit.*  Host and all guests.  Can't build Crowbar without it.

### Web Proxy
  * It's best practice to have a web proxy running somewhere.  Crowbar downloads a lot of stuff.
    * Guest proxy: gets installed by default.  You should set the http_proxy variables to your guest IP.
    * Host proxy: For greater awesomeness, install a web proxy on your Host box, so you can destroy your
      guest boxes and you won't lose everything you've downloaded.
      * Ubuntu: 
        `apt-get install polipo`
        edit `/etc/polipo/config` to listen on 0.0.0.0 and restart polipo to pick up the changes
        verify with `netstat -lntp | grep polipo`
    * NTML Proxy: some proxies are evil, and require NTLM authentication.  This is supported.

### Virtual Box
  * Download and install the latest VirtualBox: https://www.virtualbox.org/wiki/Downloads  
  * Do not use stock Ubuntu packages.  They're old.

### Vagrant
  * Download and install the latest Vagrant: http://downloads.vagrantup.com/tags/v1.0.5
  * Do not use stock Ubuntu packages.  They're old. 
    * Ubuntu:
      Vagrant's Ubuntu packages put vagrant in opt:
      `export PATH=/opt/vagrant/bin/:$PATH`

### Clone the Repo
  * Clone/download this repo: `git clone https://github.com/crowbar/crowbar-utils`
  * You may also use your own group's repo.

Prepare the Vagrant Environment for Installation
------------------------------------------------

  * Change directory to `crowbar-utils/vagrant_crowbar`
  * Edit the file `personal.json`
    * "guest_username" is the username on the guest you'd like to ssh as.
    * "user_sshpubkey" is the whole line from your host machine users's ~/.ssh/pubkey file, 
      so you can login as "guest_username" without a password.
    * "guest_proxy" and "guest_ssl_proxy" - polipo will be installed on your guest. 
      * If you want to use the guest proxy set this to http://127.0.0.1:8123.  
      * If you want to use the HOST proxy you setup earlier, use its IP address
      * If you don't want to use a proxy, you're nuts. Leave it blank.
    * Networking:
      * I make two networks: a host-only network and a bridged network. They are optional.
        * "guest_hostonly_ip": "192.168.124.5" is the IP for the host-only network.  I use 
          it for the admin network. 192.168.124.x
        * "host_network_bridge_interface": "eth0", is the nic ON THE HOST that the guest will 
          use to get DHCP IP addresses.
        * and vagrant comes up with it's own private IP for your box - usually 10.0.2.15
          with 10.0.2.2 for your host box.
    * "github_extra_remotes" Remotes are added after ./dev setup is complete. To enable,
       remove the # from the attribute name github_extra_remotes.  To disable, re-add the #. 
    * "guest_extra_packages": ["figlet","fgrep"] A place for you to add package names. 
    *BEHIND NTLM PROXY*
    *  "guest_use_cntlm": "true",
    *  "guest_parent_proxy": "127.0.0.1:8123",
    *  "polipo_mode": "work",
    *HOST (or other non-guest) PROXY*
    *  "guest_use_cntlm": "false",
    *  "guest_parent_proxy: "your parent proxy here",
    *  "polipo_mode": "work"
    *NO PROXY (except the required one on the guest)*
    *  "guest_use_cntlm": "false",
    *  "polipo_mode": "home",
    *  "rubys_to_install": "1.9.3 1.8.7", note that they're space delimited.

  * Ensure that the shared folders you're planning on using exist on the Host OS.
    * Ensure that your shared folders have open write permissions so the build box can write
      into them. 0777
  * Drop the ISO of the OSes you're planning to build with into the ISO library.

Make It So
----------

### You should be all ready.  Type: `vagrant up`

  * The box will install and the chef-solo cookbooks will run.
    * Report errors on Github, to IRC (judd7) the crowbar@lists.us.dell.com or find me on skype: juddmaltin-dell  I'm in New York, Eastern Time.
  * Once it's all installed, you can login to the box by running: `vagrant ssh`  
    * OR you can ssh as your user to the IP addresses that you setup in the personal.json file.
  * If you logged in as user `vagrant`, `sudo -i` to root, and then `su - "your username"`
  * You should have ~/crowbar all setup for you!  Switch to a release and branch, and have at it!
    * ./dev switch development/master
    * ./dev build --os ubuntu-12.04 --update-cache

Development Cycle
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

### Suspending & Resuming

It's best to suspend your system, rather than `vagrant halt` it.  Just type `vagrant suspend` from your host machine in the
Vagrantfile directory, and it'll write memory to disk and quiesce things.  `vagrant resume` does just what you think.

http://docs.vagrantup.com/v1/docs/getting-started/teardown.html

### Restarting

`vagrant halt` will finalize the image and shut it down. From then on, `vagrant up` will not re-run the 
import and provision.

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

I hope it helps you get up and developing Crowbar quickly.

-judd


