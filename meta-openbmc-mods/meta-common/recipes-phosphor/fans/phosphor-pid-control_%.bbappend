FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE_${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "5782ab81367e22e87d719c9fef6e85ecdc6cf95e"

FILES_${PN} = "${bindir}/swampd ${bindir}/setsensor"
