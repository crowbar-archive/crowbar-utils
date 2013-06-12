#!/bin/bash


ssh crowbar@admin '/opt/dell/bin/crowbar node_state status -U crowbar -P crowbar | grep -v Ready | grep  Discovered ; echo $?'
ssh crowbar@admin 'while $(/opt/dell/bin/crowbar node_state status -U crowbar -P crowbar | grep -v Ready | grep -qv Discovered ) ; do echo -n .; sleep 10; done'
echo "$? last"

echo "${SECONDS} seconds"
./my_notify.sh "holy shit, all Discovered"

