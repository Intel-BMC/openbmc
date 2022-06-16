# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/libpeci"
SRCREV = "bdefaa3c95d0a93928f8ebda1ce158172d3a4bcf"

inherit pkgconfig systemd

PACKAGECONFIG ??= ""
PACKAGECONFIG[dbus-raw-peci] = "-DDBUS_RAW_PECI=ON,-DDBUS_RAW_PECI=OFF,boost sdbusplus"
SYSTEMD_SERVICE:${PN} += "${@bb.utils.contains('PACKAGECONFIG', 'dbus-raw-peci', 'com.intel.peci.service', '', d)}"
