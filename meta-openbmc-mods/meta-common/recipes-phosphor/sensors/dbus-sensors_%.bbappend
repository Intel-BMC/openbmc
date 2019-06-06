SRCREV = "930fcde3c8776c02f2a3d969d05608e2155eb159"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod"

#todo(cheng) remove this when synced upstream
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.psusensor.service"
