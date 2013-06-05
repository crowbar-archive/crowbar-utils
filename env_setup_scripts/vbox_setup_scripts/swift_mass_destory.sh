#!/bin/bash

for x in $( VBoxManage list vms | sed -n 's/^"\(swift_[^"]*\)".*$/\1/p' );
do
  echo Destroying VM: $x ...
  VBoxManage controlvm "$x" poweroff
  VBoxManage unregistervm "$x" --delete
done


./my_notify.sh "All virtual machines destroyed."
