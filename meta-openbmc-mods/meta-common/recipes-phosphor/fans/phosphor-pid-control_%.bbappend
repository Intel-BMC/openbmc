FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE:${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "cca9c659889d149c06e95bab4b8808db4f1e3eab"

SRC_URI += "\
    file://0001-allow-dbus-sensors-without-thresholds.patch \
    "

FILES:${PN} = "${bindir}/swampd ${bindir}/setsensor"
