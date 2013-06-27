#!/bin/bash

while  ! $( nc -z admin 22 ); do
  echo -n "."
  sleep 6
done

./my_notify.sh "ssh connection available. script took ${SECONDS} seconds."

