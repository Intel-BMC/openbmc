SRC_URI =  "git://github.com/openbmc/phosphor-dbus-interfaces.git"
SRCREV = "8aec946e2844831cfc377c0e0136de5714c08a5b"

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
            "
