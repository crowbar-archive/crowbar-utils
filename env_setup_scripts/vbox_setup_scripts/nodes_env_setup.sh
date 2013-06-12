#!/bin/bash

for x in $(seq 1 9)
do
  echo $x
  if $( nc -z node${x} 22)
  then
    echo "### setting up ssh keys on node${x}"
    ssh-copy-id crowbar@node${x}
    echo "### putting localhost_env_setup.sh on box node${x}"
    scp localhost_env_setup.sh crowbar@node${x}:/home/crowbar/
    echo "### executing localhost_env_setup.sh on box node ${x}"
    ssh crowbar@node${x} 'echo crowbar | sudo -S -b /home/crowbar/localhost_env_setup.sh'
  fi
done

./my_notify.sh "All nodes are setup."
