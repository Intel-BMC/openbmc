#!/bin/sh
panicFile="/sys/fs/pstore/dmesg-ramoops-0"
if [ -f $panicFile ]
then
    # log the detailed last kernel panic messages
    logger -t kernel-panic-check "Reboot from kernel panic! Log as following:"
    cat $panicFile | logger
    # Also log it to redfish
    cat <<EOF | logger-systemd --journald
REDFISH_MESSAGE_ID=OpenBMC.0.1.BMCKernelPanic
PRIORITY=4
MESSAGE=BMC rebooted due to kernel panic
EOF

    rm -rf $panicFile
fi
