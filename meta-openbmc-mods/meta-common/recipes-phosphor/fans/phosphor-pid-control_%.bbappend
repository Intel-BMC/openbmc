FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE_${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git;nobranch=1"
SRCREV = "1277543ac599de45d15db99d15bd0e89d3653c9b"

FILES_${PN} = "${bindir}/swampd ${bindir}/setsensor"
