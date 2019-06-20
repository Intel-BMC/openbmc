SRC_URI =  "git://github.com/openbmc/phosphor-dbus-interfaces.git"
SRCREV = "1f0e2ce6e1cb78a59a0015b160816b71156b03c6"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0002-Modify-Dbus-for-IPv6.patch \
            file://0003-Chassis-Power-Control-are-implemented.patch \
            file://0005-Add-DBUS-interface-of-CPU-and-Memory-s-properties.patch \
            file://0007-ipmi-set-BIOS-id.patch \
            file://0009-Add-host-restart-cause-property.patch \
            file://0010-Increase-the-default-watchdog-timeout-value.patch \
            file://0012-Add-RestoreDelay-interface-for-power-restore-delay.patch \
            file://0013-Add-ErrConfig.yaml-interface-for-processor-error-config.patch \
            file://0014-Add-multiple-state-signal-for-host-start-and-stop.patch \
            file://0016-Add-DBUS-interface-of-SMBIOS-MDR-V2.patch \
            file://0018-Define-post-code-interfaces-for-post-code-manager.patch \
            file://0019-Creating-the-Session-interface-for-Host-and-LAN.patch \
            file://0021-Add-interface-suppot-for-provisioning-modes.patch \
            file://0022-Add-chassis-power-cycle-and-reset-to-Chassis-State.patch \
            file://0023-Add-host-interrupt-to-the-Host-State.patch \
            file://0024-Add-the-pre-timeout-interrupt-defined-in-IPMI-spec.patch \
            "
