#!/bin/bash

# this a simple builder script which can be used to easily 
# crank different builds. For example:
# To build the mesa-1.6 OpenStack release:
#   ./simple-builder.sh mesa-1.6 openstack-os-build
# To build the hadoop-2.3 release:
#   ./simple-builder.sh hadoop-2.3 cloudera-os-build


# CHANGE THIS AS APPROPIATE
CROWBAR_CHECKOUT_HOME=/home/build/cb-working/crowbar

if [[ $# -lt 2 ]]; then
    echo "Usage: simple-builder.sh mesa-1.6 openstack-os-build"
    exit 1
fi

# determine which OS to use
BRANCH=$1
BUILD=$2
OS=ubuntu-12.04
if [[ $BUILD =~ "cloudera.*" ]] ; then
    OS=centos-6.4
fi

echo "============================================================="
echo "   bulding $BUILD using $BRANCH with $OS"
echo "============================================================="

echo "......  checking out stuff ......"
cd $CROWBAR_CHECKOUT_HOME
./dev switch $BRANCH/$BUILD

# clean up any .empty-branch files first
cd $CROWBAR_CHECKOUT_HOME/barclamps
for bc in *; do (cd "$bc"; git clean -f -x -d 1>/dev/null 2>&1; git reset --hard 1>/dev/null 2>&1); done	

echo "......  attempting build ......"
cd $CROWBAR_CHECKOUT_HOME
./dev build --os $OS --wild-cache

# move the build out of the way
#mkdir -p ~/build-output/$BRANCH/unstable
#mv *$BRANCH* ~/build-output/$BRANCH/unstable




