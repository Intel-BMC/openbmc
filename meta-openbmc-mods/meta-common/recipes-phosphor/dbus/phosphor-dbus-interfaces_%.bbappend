FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0002-Modify-Dbus-for-IPv6.patch \
            file://0003-Chassis-Power-Control-are-implemented.patch \
            file://0005-Add-DBUS-interface-of-CPU-and-Memory-s-properties.patch \
            file://0006-dbus-interface-add-boot-option-support-for-floppy-an.patch \
            file://0007-ipmi-set-BIOS-id.patch \
            file://0009-Add-host-restart-cause-property.patch \
            file://0010-Increase-the-default-watchdog-timeout-value.patch \
            file://0012-Add-RestoreDelay-interface-for-power-restore-delay.patch \
            file://0013-Add-ErrConfig.yaml-interface-for-processor-error-config.patch \
            file://0014-Add-multiple-state-signal-for-host-start-and-stop.patch \
            file://0016-Add-DBUS-interface-of-SMBIOS-MDR-V2.patch \
            file://0017-Add-shutdown-policy-interface-for-get-set-shutdown-p.patch \
            file://0018-Define-post-code-interfaces-for-post-code-manager.patch \
            file://0019-Creating-the-Session-interface-for-Host-and-LAN.patch \
            file://0020-Create-dbus-interface-for-SOL-commands.patch \
            "
