FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE_${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git"
SRCREV = "6fc301fbc3775730a0e69f215110ec93bd9026f3"

FILES_${PN} = "${bindir}/swampd ${bindir}/setsensor"

SRC_URI += "file://0001-Eliminate-swampd-core-dump-after-D-Bus-updates-senso.patch \
            file://0002-Prevent-run-away-memory-consumption-from-swamped.patch \
            file://0003-fix-phosphor-pid-control-crash-when-fail-to-create-p.patch \
           "
