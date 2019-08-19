SRC_URI =  "git://github.com/openbmc/phosphor-dbus-interfaces.git"
SRCREV = "ddc9e9f9d6ed0282ec6c1421a706b45f3c09ebcc"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0005-Add-DBUS-interface-of-CPU-and-Memory-s-properties.patch \
            file://0007-ipmi-set-BIOS-id.patch \
            file://0010-Increase-the-default-watchdog-timeout-value.patch \
            file://0012-Add-RestoreDelay-interface-for-power-restore-delay.patch \
            file://0013-Add-ErrConfig.yaml-interface-for-processor-error-config.patch \
            file://0016-Add-DBUS-interface-of-SMBIOS-MDR-V2.patch \
            file://0018-Define-post-code-interfaces-for-post-code-manager.patch \
            file://0021-D-Bus-Intf-Security-modes-property-intf-update.patch \
            file://0022-Add-chassis-power-cycle-and-reset-to-Chassis-State.patch \
            file://0024-Add-the-pre-timeout-interrupt-defined-in-IPMI-spec.patch \
            file://0025-Add-PreInterruptFlag-properity-in-DBUS.patch \
            "
