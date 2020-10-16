SRCREV = "8aeffd91ff3434f7812e9fdb6b0b03c6119921dd"
#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'disable-nvme-sensors', d)}"
PACKAGECONFIG[disable-nvme-sensors] = "-DDISABLE_NVME=ON, -DDISABLE_NVME=OFF"

SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'disable-nvme-sensors', '', 'xyz.openbmc_project.nvmesensor.service', d)}"
