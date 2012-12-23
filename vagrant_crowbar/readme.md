vagrant_crowbar
===============

This is to setup a dev and build environment for developer/tester use.

This is NOT the an attempt to deploy the Crowbar Admin node through Vagrant.  For that, have a look at https://github.com/dellcloudedge/crowbar-utils/tree/master/test_deploy_utils


How To:
=======

Download and install the latest VirtualBox: https://www.virtualbox.org/wiki/Downloads  
  Do not use stock Ubuntu packages.  They're old.

Download and install the latest Vagrant: http://downloads.vagrantup.com/tags/v1.0.5
  Do not use stock Ubuntu packages.  They're old.

Clone/download this repo: https://github.com/dellcloudedge/crowbar-utils

Change directory to crowbar-utils/vagrant_crowbar

Edit the file personal.json

I recommend making sure your proxy is running on the Host OS and that your http_proxy settings
  point there from the guest you're creating.

Ensure that the shared folders you're planning on using exist on the Host OS.

Drop the ISO of the OSes you're planning to build with into the ISO library.

You should be all ready.  Type: vagrant up

The box will install and the chef-solo cookbooks will run.

Once it's all installed, you can login to the box by running: vagrant ssh  OR you can ssh as your user to the IP addresses that you setup in the personal.json file.

If you logged in as user vagrant, sudo -i to root, and then su - <username>

You should have ~/crowbar all setup for you!  Switch to a release and branch, and have at it!

Please let me know what you find: submit bug reports, email me, find me on IRC, or best of all, fork the code and submit pull-requests!

I hope it helps you get up and developing Crowbar quickly.

-judd
