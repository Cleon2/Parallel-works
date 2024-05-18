#!/bin/bash

IDFile="/tmp/my_id_file"

if [ ! -f "${IDFile}" ]; then
   ID=0
else
   ID=`cat ${IDFile}`
fi

ID=$((ID+1))

rng=$((RANDOM % 6))

printf "%0${rng}d\n" $ID

echo $ID >${IDFile}
