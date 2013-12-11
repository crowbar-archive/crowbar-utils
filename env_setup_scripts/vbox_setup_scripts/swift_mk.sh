#!/bin/bash

# swift_mk_node.sh expects: NAME DISK_SIZE NUM_DISKS NUM_CPU NUM_RAM(MB) 

#set -x
# create three proxy nodes with 50 gb drives
#./swift_mk_node.sh controller 50000 1 2 6000
./swift_mk_node.sh vms1 50000 1 2 6000
./swift_mk_node.sh vms2 50000 1 2 4000

# create three storage nodes with 3 additional 
#./swift_mk_node.sh storage1 50000 3 2 5000
#./swift_mk_node.sh storage2 50000 3
#./swift_mk_node.sh storage3 50000 3



./my_notify.sh "Swift nodes created."
