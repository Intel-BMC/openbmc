FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE:${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "e7507a8b55136accc501408d691bd816abc4833f"

SRC_URI += "\
    file://0001-allow-dbus-sensors-without-thresholds.patch \
    "

FILES:${PN} = "${bindir}/swampd ${bindir}/setsensor"
