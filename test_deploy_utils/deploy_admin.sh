#!/bin/bash

# Script originally written for cygwin - now on ubuntu, should still work on Cygwin
# Intended to be run from the Host system running Virtual Box
# VM name is the VBox name of your admin server, already configured for running the
# Crowbar Admin server (must have machine already setup.. networking, disk, etc)

# $1 = admin VM name (glob)
# $2 = full path to ISO

VM_NAME=${1}
ISO_PATH=${2}

echo VM_NAME=${VM_NAME}
echo ISO_PATH=${ISO_PATH}

# test OS
if [[ $( uname -a ) == *"CYGWIN"* ]]
then
        CYGWIN=1
fi

# path to VBoxManage
VBOX_M='/usr/bin/VBoxManage'
[[ $CYGWIN == '1' ]] && VBOX_M='/drives/c/Program Files/Oracle/VirtualBox/VBoxManage.exe'

# Get the list of VMs that match  $1
VM=$("$VBOX_M" list vms | grep $VM_NAME  )

# test to make sure we only have one VM to reset
if [[ $( echo "${VM}" | wc -l ) > 1 ]]
then
        echo ERROR: more than one match, must only be one.  Pick a better glob.  Exiting.
        exit 1
fi

echo "Virtual machine I am resetting now: ${VM}"

# get the UID of the VM
VM=$("$VBOX_M" list vms | grep $1 | cut -d"{" -f2 | cut -d"}" -f1  )

# TODO
# find the empty DVD drive in the VM: "usually 1,0"

# change ISO path style from cygwin to Windows (if necessary)
[[ $CYGWIN == '1' ]] && ISO_PATH=$(cygpath -w ${ISO_PATH})
echo "Path to ISO I am booting with: ${ISO_PATH}"

# attach that medium, assuming that the vm already let go of the previous one
"$VBOX_M" storageattach "${VM}" --storagectl "IDE Controller" --medium "${ISO_PATH}" --port 1 --device 0 --type dvddrive

# restart th VM, with vengance
"$VBOX_M" controlvm "${VM}" reset || "$VBOX_M" startvm "${VM}" 

echo "All done.  Enjoy your new Admin Server."
exit 0

