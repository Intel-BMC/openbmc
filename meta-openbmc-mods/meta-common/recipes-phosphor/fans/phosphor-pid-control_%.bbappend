FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE_${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "298a95cbb192ecc678b1a496acc954a3b2adf450"

FILES_${PN} = "${bindir}/swampd ${bindir}/setsensor"
