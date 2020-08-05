SRCREV = "5591cf0860895607bda0b8ae713e6b05ac0623b1"
#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'disable-nvme-sensors', d)}"
PACKAGECONFIG[disable-nvme-sensors] = "-DDISABLE_NVME=ON, -DDISABLE_NVME=OFF"

SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'disable-nvme-sensors', '', 'xyz.openbmc_project.nvmesensor.service', d)}"
