#!/bin/bash

if /sbin/fw_printenv bootfailures -n | grep -q 3; then
    exit 0 # passed boot limit, user started again on purpose
fi

systemctl stop system-watchdog.service
/sbin/watchdog -T 0 -F /dev/watchdog1
