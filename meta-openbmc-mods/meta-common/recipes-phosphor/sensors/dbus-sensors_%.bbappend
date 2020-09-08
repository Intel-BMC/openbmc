SRCREV = "623723b9e827f52a05cfe2dac8b4ef5d285fb6af"
#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'disable-nvme-sensors', d)}"
PACKAGECONFIG[disable-nvme-sensors] = "-DDISABLE_NVME=ON, -DDISABLE_NVME=OFF"

SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'disable-nvme-sensors', '', 'xyz.openbmc_project.nvmesensor.service', d)}"
