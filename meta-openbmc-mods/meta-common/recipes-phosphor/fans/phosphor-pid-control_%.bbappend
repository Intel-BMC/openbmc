FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE_${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "f42741197ec807e0436a5e519ccff18519c67248"
