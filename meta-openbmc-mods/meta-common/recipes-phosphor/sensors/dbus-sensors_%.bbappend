SRCREV = "54ffb271b995db4f0b00f0661baab23763fae5bd"
#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

EXTRA_OECMAKE += "-DDISABLE_NVME=OFF"
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.nvmesensor.service"
