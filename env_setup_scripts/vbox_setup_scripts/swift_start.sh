#!/bin/bash

for x in $( VBoxManage list vms | sed -n 's/^"\(swift_[^"]*\)".*$/\1/p' );
do
  echo Starting VM: $x ...
  VBoxManage startvm "$x"
  ./my_notify.sh "Starting V M $x"
  echo "waiting 60 seconds ..."
  sleep 60
  echo done waiting
done

./my_notify.sh "All swift nodes started."
