#!/bin/sh
value=`cat /sys/devices/platform/ahb/ahb:apb/1e6e2000.syscon/1e6e2000.syscon:misc_control/uart_port_debug`
if [ $value == 0 ]
    then
    # log the detailed last security registers check messages
    logger -t security-registers-check "Uart port debug is enabled! Log as following:"
    echo "Uart port debug is enabled." | logger
    # Also log it to redfish
    cat <<EOF | logger-systemd --journald
REDFISH_MESSAGE_ID=OpenBMC.0.1.SecurityUartPortDebugEnabled
PRIORITY=4
MESSAGE=BMC Uart port debug is enabled
EOF
fi

value=`cat /sys/devices/platform/ahb/ahb:apb/1e6e2000.syscon/1e6e2000.syscon:misc_control/p2a-bridge`
if [ $value == 1 ]
    then
    # log the detailed last security registers check messages
    logger -t security-registers-check "P2A(PCIe to AHB) bridge is enabled! Log as following:"
    echo "P2A(PCIe to AHB) bridge is enabled." | logger
    # Also log it to redfish
    cat <<EOF | logger-systemd --journald
REDFISH_MESSAGE_ID=OpenBMC.0.1.SecurityP2aBridgeEnabled
PRIORITY=4
MESSAGE=BMC P2A(PCIe to AHB) bridge is enabled
EOF
fi

value=`cat /sys/devices/platform/ahb/ahb:apb/1e6e2000.syscon/1e6e2000.syscon:misc_control/boot-2nd-flash`
if [ $value == 1 ]
    then
    # log the detailed last security registers check messages
    logger -t security-registers-check "BMC 2nd boot flash is enabled! Log as following:"
    echo "BMC 2nd boot flash is enabled." | logger
    # Also log it to redfish
    cat <<EOF | logger-systemd --journald
REDFISH_MESSAGE_ID=OpenBMC.0.1.SecurityBoot2ndFlashEnabled
PRIORITY=4
MESSAGE=BMC 2nd boot flash is enabled
EOF
fi
