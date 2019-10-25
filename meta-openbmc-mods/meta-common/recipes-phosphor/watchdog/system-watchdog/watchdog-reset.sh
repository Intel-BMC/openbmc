#!/bin/bash

if /sbin/fw_printenv bootfailures -n | grep -q 3; then
    exit 0 # passed boot limit, user started again on purpose
fi

echo "Watchdog Failure Limit Reached, Failed Processes:" > /dev/kmsg
systemctl --failed --no-pager | grep failed > /dev/kmsg
echo "Log as follows:" > /dev/kmsg
journalctl -r -n 100 | while read line; do echo $line > /dev/kmsg; done

systemctl stop system-watchdog.service
/sbin/watchdog -T 0 -F /dev/watchdog1
