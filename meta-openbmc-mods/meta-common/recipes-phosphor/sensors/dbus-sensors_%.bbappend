SRCREV = "3546adb92b6fb36322e9bfb60c722ca2af9478d6"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"
SRC_URI += "file://0001-Add-WA-enable-disable-control-code-into-cpusensor.patch"

#todo(cheng) remove this when synced upstream
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.mcutempsensor.service"
