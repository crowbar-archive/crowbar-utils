Crowbar 2 + Docker + Ubuntu 12.04.02 or OpenSuse
================================================

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

### Edit personal.json.example

(see readme.md in vagrant_crowbar directory in this repo)

### Ensure shared ISOs

Crowbar needs Ubuntu and Centos to build all its parts.  Make sure the following ISOs are
in "crowbar_iso_library":
* CentOS-6.2-x86_64-bin-DVD1.iso
* ubuntu-12.04.2-server-amd64.iso
