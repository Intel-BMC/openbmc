SRCREV = "52497fd0fbd8adfe099a99f23515cd0341898e2e"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod"

#todo(cheng) remove this when synced upstream
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.psusensor.service"
