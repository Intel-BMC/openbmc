#SRC_URI =  "git://github.com/openbmc/phosphor-dbus-interfaces.git"
SRCREV = "395ba2176054745ff453f056e0593d3c2d802ea8"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0007-ipmi-set-BIOS-id.patch \
            file://0010-Increase-the-default-watchdog-timeout-value.patch \
            file://0012-Add-RestoreDelay-interface-for-power-restore-delay.patch \
            file://0013-Add-ErrConfig.yaml-interface-for-processor-error-config.patch \
            file://0024-Add-the-pre-timeout-interrupt-defined-in-IPMI-spec.patch \
            file://0025-Add-PreInterruptFlag-properity-in-DBUS.patch \
            file://0026-Add-StandbySpare-support-for-software-inventory.patch \
            file://0031-update-meson-build-files-for-control-and-bios.patch \
            "
