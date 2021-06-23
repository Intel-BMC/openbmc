FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE_${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "18d5bb18dcb4ebf7340b0b7a0b39daa887d530ce"

SRC_URI += "\
    file://0001-allow-dbus-sensors-without-thresholds.patch \
    "

FILES_${PN} = "${bindir}/swampd ${bindir}/setsensor"
