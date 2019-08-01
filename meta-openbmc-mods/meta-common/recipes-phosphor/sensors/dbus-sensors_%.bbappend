SRCREV = "1cbd1c6da17a85ec7213744cf2d1e56fcba3e34e"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod"

#todo(cheng) remove this when synced upstream
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.mcutempsensor.service"
