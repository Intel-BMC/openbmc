SRCREV = "93dc2c8e7c710fd65d269ef0bf684fb7a433a602"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " i2c-tools"

#todo(cheng) remove this when synced upstream
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.psusensor.service"
