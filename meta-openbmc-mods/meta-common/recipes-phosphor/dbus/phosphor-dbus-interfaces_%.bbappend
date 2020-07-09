SRC_URI =  "git://github.com/openbmc/phosphor-dbus-interfaces.git;nobranch=1"

# todo(Johnathan) fix nobranch
SRCREV = "26ff1c84469e470e28257f3584e1b1126d4783f0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0005-Add-DBUS-interface-of-CPU-and-Memory-s-properties.patch \
            file://0007-ipmi-set-BIOS-id.patch \
            file://0010-Increase-the-default-watchdog-timeout-value.patch \
            file://0012-Add-RestoreDelay-interface-for-power-restore-delay.patch \
            file://0013-Add-ErrConfig.yaml-interface-for-processor-error-config.patch \
            file://0024-Add-the-pre-timeout-interrupt-defined-in-IPMI-spec.patch \
            file://0025-Add-PreInterruptFlag-properity-in-DBUS.patch \
            file://0001-Reapply-Enhance-DHCP-beyond-just-OFF-and-IPv4-IPv6-e.patch \
            file://0026-Add-StandbySpare-support-for-software-inventory.patch \
            file://0027-Apply-Options-interface-for-Software.patch \
            file://0028-MCTP-Daemon-D-Bus-interface-definition.patch \
            "
