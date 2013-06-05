#!/bin/bash

# (c) 2013, Dell
# Author: Judd Maltin

# searches for latest build at $CROWBAR_DIR.
# finds $CROWBAR_DIR in ~/.build-crowbar.conf.

# $1 = admin VM name (glob)

source ${HOME}/.build-crowbar.conf


VM_NAME=${1}

LAST_ISO=`ls ${CROWBAR_DIR}/*.dev.iso | tail -1`

echo ${LAST_ISO}

cd $(basename "${0}")

./admin_deploy.sh ${1} ${LAST_ISO}


