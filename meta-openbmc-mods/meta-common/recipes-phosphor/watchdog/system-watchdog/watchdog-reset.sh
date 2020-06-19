#!/bin/bash

echo "Watchdog being started by $1" > /dev/kmsg

if /sbin/fw_printenv bootfailures -n | grep -q 3; then
    exit 0 # passed boot limit, user started again on purpose
fi

if test -f "/tmp/nowatchdog"; then
    echo "Not resetting due to nowatchdog file" > /dev/kmsg
    exit 0
fi

echo "Log as follows:" > /dev/kmsg
journalctl -r -n 100 | while read line; do echo $line > /dev/kmsg; done

systemctl stop system-watchdog.service
/sbin/watchdog -T 0 -F /dev/watchdog1
