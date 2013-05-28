#!/bin/bash

echo '### copying your ssh key to admin box'
ssh-copy-id crowbar@admin

echo '### starting crowbar install on admin box'
ssh -t crowbar@admin 'sudo /opt/dell/bin/install-crowbar admin.crowbar.org --no-screen'


