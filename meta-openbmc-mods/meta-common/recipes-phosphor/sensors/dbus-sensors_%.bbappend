SRCREV = "3840d0ad45134597455f6d70fe1ae76f3cac0e7d"
#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

EXTRA_OECMAKE += "-DDISABLE_NVME=OFF"
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.nvmesensor.service"
