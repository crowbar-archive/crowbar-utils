#!/bin/bash

# make swift proxy nodes

# argv
NAME="swift_pxe_${1}"
DISK_SIZE=$2
NUM_DRIVES=$3

# paths
DEFAULT_FOLDER="/$(VBoxManage list systemproperties | grep "^Default machine folder:" | cut -d'/' -f 2-)/"
echo "DEFAULT_FOLDER = $DEFAULT_FOLDER"

DISK_PATH="${DEFAULT_FOLDER}/${NAME}/"
DISK_NAME="${DEFAULT_FOLDER}/${NAME}/${NAME}.vdi"
echo "DISK_PATH = ${DISK_PATH}"

# clean up old stuff
VBoxManage unregistervm pxe${NAME} --delete
rm -rf "$VMPATH"

# create a new vm
VBoxManage createvm --name ${NAME} --ostype Ubuntu_64 --register 
VBoxManage modifyvm  ${NAME} --memory 1000

# add drive controllers
VBoxManage storagectl  "${NAME}" --name 'IDE' --add ide

SATA_PORT_COUNT=1
if [ ! -z "$NUM_DRIVES" ]
then
  SATA_PORT_COUNT=$((${NUM_DRIVES} + 1))
fi
echo "SATA_PORT_COUNT = ${SATA_PORT_COUNT}"

VBoxManage storagectl "${NAME}" --name 'SATA' --add sata --hostiocache off --sataportcount ${SATA_PORT_COUNT}

# create drive images
VBoxManage createhd --filename "$DISK_NAME" --size ${DISK_SIZE} --format VDI 

# attach images
VBoxManage storageattach "${NAME}" --storagectl 'SATA' --port 0 --device 0 --type hdd --medium "$DISK_NAME"

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

VBoxManage modifyvm ${NAME} --nic1 hostonly
VBoxManage modifyvm ${NAME} --nic2 hostonly
VBoxManage modifyvm ${NAME} --nic3 hostonly
VBoxManage modifyvm ${NAME} --nic4 hostonly
VBoxManage modifyvm ${NAME} --macaddress1 auto
VBoxManage modifyvm ${NAME} --macaddress2 auto
VBoxManage modifyvm ${NAME} --macaddress3 auto
VBoxManage modifyvm ${NAME} --macaddress4 auto
#VBoxManage modifyvm ${NAME} --nictype1 $IF_TYPE
#VBoxManage modifyvm ${NAME} --nictype2 $IF_TYPE
#VBoxManage modifyvm ${NAME} --nictype3 $IF_TYPE
#VBoxManage modifyvm ${NAME} --nictype4 $IF_TYPE
#VBoxManage modifyvm ${NAME} --cableconnected2 off
#VBoxManage controlvm ${NAME} setlinkstate2 off
#VBoxManage modifyvm ${NAME} --cableconnected3 off
#VBoxManage controlvm ${NAME} setlinkstate3 off
VBoxManage modifyvm ${NAME} --hostonlyadapter1 vboxnet0
VBoxManage modifyvm ${NAME} --hostonlyadapter2 vboxnet2
VBoxManage modifyvm ${NAME} --hostonlyadapter3 vboxnet3
VBoxManage modifyvm ${NAME} --hostonlyadapter4 vboxnet5
VBoxManage modifyvm ${NAME} --boot1 net

#rm boxes/${NAME}.box
#bundle exec vagrant box remove 'server1'
#bundle exec vagrant basebox export ${NAME}
#mv '${NAME}.box' boxes/
#bundle exec vagrant box add 'server1' 'boxes/${NAME}.box'
