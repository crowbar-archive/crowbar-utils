#!/bin/bash

while  ! $( nc -z admin 3000 ); do
  echo -n "."
  sleep 6
done

/usr/bin/firefox http://192.168.124.10:3000/ &

./my_notify.sh "Crowbar admin webserver available. script took ${SECONDS} seconds."

