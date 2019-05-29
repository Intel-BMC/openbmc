SRCREV = "8dbb395364629673a1f1dde81b1cf7d8041b0662"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " i2c-tools"

#todo(cheng) remove this when synced upstream
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.psusensor.service"
