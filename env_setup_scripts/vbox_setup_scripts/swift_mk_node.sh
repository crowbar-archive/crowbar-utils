#!/bin/bash

# make swift proxy nodes

# IMPORTANT: setup your network as follows

ADMIN_NET="vboxnet0"   # 192.168.124.0
PUBLIC_NET="vboxnet2" # 192.168.122.0
PRIVATE_NET="vboxnet3" # 192.168.123.0
STORAGE_NET="vboxnet5" # 192.168.125.0

NIC1_NET=${ADMIN_NET}
NIC2_NET=${PUBLIC_NET}
NIC3_NET=${PRIVATE_NET}
NIC4_NET=${STORAGE_NET}

# argv
typeset -i NUM_CPU NUM_RAM DISK_SIZE NUM_DRIVES
NAME="swift_pxe_${1}"
DISK_SIZE=${2:-5000}
NUM_DRIVES=${3:-1}
NUM_CPU=${4:-1}
NUM_RAM=${5:-1000}

VBOX_M="\"${VBOX_INSTALL_PATH}vboxmanage\""
echo $VBOX_M

# paths
DEFAULT_FOLDER="/$(${VBOX_M} list systemproperties | grep "^Default machine folder:" | cut -d'/' -f 2-)/"
echo "DEFAULT_FOLDER = $DEFAULT_FOLDER"

exit 0

DISK_PATH="${DEFAULT_FOLDER}/${NAME}/"
DISK_NAME="${DEFAULT_FOLDER}/${NAME}/${NAME}.vdi"
echo "DISK_PATH = ${DISK_PATH}"

# clean up old stuff
VBoxManage unregistervm pxe${NAME} --delete
rm -rf "$VMPATH"

# create a new vm
VBoxManage createvm --name ${NAME} --ostype Ubuntu_64 --register 
VBoxManage modifyvm  ${NAME} --memory ${NUM_RAM} --cpus ${NUM_CPU}

# add drive controllers
VBoxManage storagectl  "${NAME}" --name 'IDE' --add ide

SATA_PORT_COUNT=$((${NUM_DRIVES} + 1))

echo "SATA_PORT_COUNT = ${SATA_PORT_COUNT}"

VBoxManage storagectl "${NAME}" --name 'SATA' --add sata --hostiocache off --sataportcount ${SATA_PORT_COUNT}

# create drive image for first drive
VBoxManage createhd --filename "$DISK_NAME" --size ${DISK_SIZE} --format VDI 

# attach image for first drive
VBoxManage storageattach "${NAME}" --storagectl 'SATA' --port 0 --device 0 --type hdd --medium "$DISK_NAME"

# create and attach the rest of the drives
if [ ! -z "$NUM_DRIVES" ]
then
  I=0
  while [ $I -lt $NUM_DRIVES ]
  do
    let I+=1
    # create drive images
    MEDIUM="${DISK_PATH}${NAME}-${I}.vdi" 
    VBoxManage createhd --filename "${MEDIUM}" --size ${DISK_SIZE} --format VDI 

    # attach images
    VBoxManage storageattach "${NAME}" --storagectl 'SATA' --port ${I} --device 0 --type hdd --medium "${MEDIUM}"
  done 
fi 

# network stuff

# hostonly networks only - no NAT, etc.
VBoxManage modifyvm ${NAME} --nic1 hostonly
VBoxManage modifyvm ${NAME} --nic2 hostonly
VBoxManage modifyvm ${NAME} --nic3 hostonly
VBoxManage modifyvm ${NAME} --nic4 hostonly
VBoxManage modifyvm ${NAME} --macaddress1 auto
VBoxManage modifyvm ${NAME} --macaddress2 auto
VBoxManage modifyvm ${NAME} --macaddress3 auto
VBoxManage modifyvm ${NAME} --macaddress4 auto
# don't bother with interface types - use default
#VBoxManage modifyvm ${NAME} --nictype1 $IF_TYPE
#VBoxManage modifyvm ${NAME} --nictype2 $IF_TYPE
#VBoxManage modifyvm ${NAME} --nictype3 $IF_TYPE
#VBoxManage modifyvm ${NAME} --nictype4 $IF_TYPE
# don't noodle with link states, we don't care
#VBoxManage modifyvm ${NAME} --cableconnected2 off
#VBoxManage controlvm ${NAME} setlinkstate2 off
#VBoxManage modifyvm ${NAME} --cableconnected3 off
#VBoxManage controlvm ${NAME} setlinkstate3 off

VBoxManage modifyvm ${NAME} --hostonlyadapter1 ${NIC1_NET}
VBoxManage modifyvm ${NAME} --hostonlyadapter2 ${NIC2_NET}
VBoxManage modifyvm ${NAME} --hostonlyadapter3 ${NIC3_NET}
VBoxManage modifyvm ${NAME} --hostonlyadapter4 ${NIC4_NET}
VBoxManage modifyvm ${NAME} --boot1 net

#rm boxes/${NAME}.box
#bundle exec vagrant box remove 'server1'
#bundle exec vagrant basebox export ${NAME}
#mv '${NAME}.box' boxes/
#bundle exec vagrant box add 'server1' 'boxes/${NAME}.box'
