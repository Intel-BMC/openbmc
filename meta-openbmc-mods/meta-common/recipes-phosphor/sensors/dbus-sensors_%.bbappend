SRCREV = "d9d8cafcb1f4096e579188478b88cb8cefca8bd4"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

EXTRA_OECMAKE += "-DDISABLE_NVME=OFF"
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.nvmesensor.service"
