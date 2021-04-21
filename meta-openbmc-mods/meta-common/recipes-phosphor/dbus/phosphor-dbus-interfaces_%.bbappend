# Keep this as a comment to enable the auto-bump script without
# stomping on SRC_URI from previous .bbappend files
#SRC_URI =  "git://github.com/openbmc/phosphor-dbus-interfaces.git"
SRCREV = "ae956ad9efd2be24c5439a4ef6498fb5c8383719"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0007-ipmi-set-BIOS-id.patch \
            file://0010-Increase-the-default-watchdog-timeout-value.patch \
            file://0012-Add-RestoreDelay-interface-for-power-restore-delay.patch \
            file://0013-Add-ErrConfig.yaml-interface-for-processor-error-config.patch \
            file://0024-Add-the-pre-timeout-interrupt-defined-in-IPMI-spec.patch \
            file://0025-Add-PreInterruptFlag-properity-in-DBUS.patch \
            file://0026-Add-StandbySpare-support-for-software-inventory.patch \
            file://0028-MCTP-Daemon-D-Bus-interface-definition.patch \
            file://0029-Add-D-Bus-interfaces-for-PLDM-FW-update.patch \
            file://0031-update-meson-build-files-for-control-and-bios.patch \
            file://0030-Add-PLDM-version-purpose-enumeration.patch \
            file://0032-update-meson-build-for-MCTP-interfaces.patch \
            file://0033-update-meson-build-for-PLDM-FWU-interfaces.patch \
            "
