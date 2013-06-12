#!/bin/bash

echo '### copying your ssh key to admin box'
ssh-copy-id crowbar@admin

echo '### put localhost_admin_setup.sh on admin box'
scp localhost_* crowbar@admin:/home/crowbar/

echo '### execute localhost_admin_setup.sh on admin server'
ssh -t crowbar@admin sudo /home/crowbar/localhost_env_setup.sh

