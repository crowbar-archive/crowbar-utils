#!/bin/bash

echo '### copying your ssh key to admin box'
ssh-copy-id crowbar@admin

echo ### add passwordless sudo to crowbar user
#ssh -t crowbar@admin 'echo "crowbar ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'

#echo '### starting crowbar install on admin box'
#ssh -t crowbar@admin 'echo crowbar | sudo -S -b /opt/dell/bin/install-crowbar admin.crowbar.org --no-screen'
ssh -t crowbar@admin 'sudo /opt/dell/bin/install-crowbar admin.crowbar.org --no-screen'


./my_notify.sh "Crowbar Installed.  You may now deploy nodes."
