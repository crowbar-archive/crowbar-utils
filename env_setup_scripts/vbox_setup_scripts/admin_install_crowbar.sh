#!/bin/bash

echo '### execute localhost_admin_crowbar_setup.sh on admin server'
ssh -t crowbar@admin sudo /home/crowbar/localhost_admin_crowbar_setup.sh

./my_notify.sh "Crowbar admin server Installed."
echo "### script too ${SECONDS} seconds."

