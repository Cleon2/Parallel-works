#!/bin/bash

IDFile="/tmp/my_id_file"
GeneratedIDList="/tmp/generated_ids"

if [ -f ${IDFile} ]; then
   rm ${IDFile}
fi

echo -n "" > ${GeneratedIDList}
for i in {1..1000}; do
   (./genid.sh >> ${GeneratedIDList} &)
done
