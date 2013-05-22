#!/bin/bash

# create three proxy nodes with 50 gb drives
./mk_swift_node.sh proxy1 50000
./mk_swift_node.sh proxy2 50000
./mk_swift_node.sh proxy3 50000

# create three storage nodes with 3 additional 
./mk_swift_node.sh storage1 50000 3
./mk_swift_node.sh storage2 50000 3
./mk_swift_node.sh storage3 50000 3





