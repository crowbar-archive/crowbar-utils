#!/bin/bash

echo '### copying your ssh key to node '
ssh-copy-id crowbar@node${1}

echo ### add passwordless sudo to crowbar user
ssh -t crowbar@node${1} 'echo "crowbar ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'



./my_notify.sh "Setup sudo and nice stuff on node ${1}.  "
