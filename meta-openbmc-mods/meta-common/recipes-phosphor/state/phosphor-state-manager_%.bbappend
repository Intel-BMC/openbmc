FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Modify-dbus-interface-for-power-control.patch \
            file://phosphor-reboot-host@.service \
            file://phosphor-reset-host-reboot-attempts@.service \
            file://phosphor-reset-host-check@.service \
            file://0002-Capture-host-restart-cause.patch \
            file://0003-Use-warm-reboot-for-the-Reboot-host-state-transition.patch \
            file://0004-Add-Power-Restore-delay-support.patch \
            "
