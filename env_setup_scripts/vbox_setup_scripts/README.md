Judd's Workflow:

admin_deploy.sh
===============

Script to speed up Crowbar ISO testing.  Runs on Virtual Box host systems to ease the re-deployment of Crowbar Admin node ISOs.

./admin_deploy.sh <GLOB OF TARGET VM> <path to ISO>

admin_env_setup.sh
==================

Sets up ssh-keys and some nice tools on admin server.

admin_install_crowbar.sh
================

Script to login to admin box and kick off crowbar install.

Takes FOREVER. While waiting, do swift_mk.sh

swift_mk.sh
===========

Do it while waiting for the above.
Scripts to make Virtual Box machines for PXE booting.  
Open up the file and hack on it for the child scripts to make the
boxes that you need.

swift_start.sh
==============

admin_install_crowbar.rb needs to have completed OK.

Starts up all the swift nodes.  

TODO:
=====

Setup networking correctly.
