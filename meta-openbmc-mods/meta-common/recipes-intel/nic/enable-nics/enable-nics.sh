#!/bin/sh

SEMAPHORE_FILE=/var/cache/private/nic_fixup_complete

if [ -a $SEMAPHORE_FILE ]; then
    exit 0
fi

for nicFile in /etc/systemd/network/*.network
do
    sed -i -e"/Unmanaged/d" $nicFile
done

touch $SEMAPHORE_FILE
