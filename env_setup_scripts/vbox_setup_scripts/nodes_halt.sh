#!/bin/bash

for x in $(seq 1 9)
do
  echo $x
  if $( nc -z node${x} 22)
  then
    ssh -t crowbar@node${x} 'sudo halt'
  fi
done

./my_notify "All nodes are halted."
