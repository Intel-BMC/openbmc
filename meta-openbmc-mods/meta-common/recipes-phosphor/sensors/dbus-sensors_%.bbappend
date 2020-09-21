SRCREV = "2456dde72421cd4086ac43e619fb0817a55bf0a7"
#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'disable-nvme-sensors', d)}"
PACKAGECONFIG[disable-nvme-sensors] = "-DDISABLE_NVME=ON, -DDISABLE_NVME=OFF"

SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'disable-nvme-sensors', '', 'xyz.openbmc_project.nvmesensor.service', d)}"
