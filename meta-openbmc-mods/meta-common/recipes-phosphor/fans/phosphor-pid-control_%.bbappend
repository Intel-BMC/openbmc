FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE_${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "6b9f59991b7f694866c98775b4179ae97c5e69a8"

FILES_${PN} = "${bindir}/swampd ${bindir}/setsensor"
