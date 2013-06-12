#!/bin/bash

ssh-copy-id crowbar@admin

ssh crowbar@admin 'while $(/opt/dell/bin/crowbar node_state status -U crowbar -P crowbar | grep -v Readying | grep -qv Ready ) ; do echo -n .; sleep 10; done'
echo "$? last"

echo "${SECONDS} seconds"
./my_notify.sh "holy shit, all nodes are Ready"

