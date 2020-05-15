SRCREV = "17aba776373e14851a04e6b9ac518622b117b2a1"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

EXTRA_OECMAKE += "-DDISABLE_NVME=OFF"
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.nvmesensor.service"
