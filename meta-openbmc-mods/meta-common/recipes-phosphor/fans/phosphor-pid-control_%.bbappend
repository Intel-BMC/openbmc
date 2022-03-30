FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE:${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "457993f836338aa0c13a32af803fcbc5227c81f3"

SRC_URI += "\
    file://0001-allow-dbus-sensors-without-thresholds.patch \
    "

FILES:${PN} = "${bindir}/swampd ${bindir}/setsensor"
