#!/bin/bash

IDFile="/tmp/my_id_file"
LockFile="/tmp/my_id_lock"

# Acquire the lock
exec 200>"${LockFile}"


# Wait to acquire the lock
flock -x 200

# Read and increment the ID
if [ ! -f "${IDFile}" ]; then
    ID=0
else
    if ! ID=$(<"${IDFile}"); then
        echo "Error reading ID file" >&2
        exit 1
    fi
fi

ID=$((ID + 1))

# Format the ID to be 5 digits wide
printf -v formattedID "%05d" "${ID}"
echo "${formattedID}"

# Save the new ID
echo "${ID}" > "${IDFile}"

# The lock is released when the script exits
flock -u 200
