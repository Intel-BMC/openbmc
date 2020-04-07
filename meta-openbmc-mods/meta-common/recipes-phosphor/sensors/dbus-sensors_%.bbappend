SRCREV = "6b1247a16d52be853c18015e7163d60abce5c00a"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

EXTRA_OECMAKE += "-DDISABLE_NVME=OFF"
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.nvmesensor.service"
