#!/bin/bash


# path to VBoxManage
[[ $CYGWIN == '1' ]] && echo '/drives/c/Program Files/Oracle/VirtualBox/VBoxManage.exe' && exit 0
echo '/usr/bin/VBoxManage'
