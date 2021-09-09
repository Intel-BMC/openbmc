FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

SRCREV = "8aeffd91ff3434f7812e9fdb6b0b03c6119921dd"
#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

SRC_URI += "\
    file://intrusionsensor-depend-on-networkd.conf \
    file://0001-Fix-for-intrusionsensor-service-crash.patch \
    file://0003-Add-check-for-min-max-received-from-hwmon-files.patch \
    "

DEPENDS_append = " libgpiod libmctp"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'disable-nvme-sensors', d)}"
PACKAGECONFIG[disable-nvme-sensors] = "-DDISABLE_NVME=ON, -DDISABLE_NVME=OFF"

SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'disable-nvme-sensors', '', 'xyz.openbmc_project.nvmesensor.service', d)}"

do_install_append() {
    svc="xyz.openbmc_project.intrusionsensor.service"
    srcf="${WORKDIR}/intrusionsensor-depend-on-networkd.conf"
    dstf="${D}/etc/systemd/system/${svc}.d/10-depend-on-networkd.conf"
    mkdir -p "${D}/etc/systemd/system/${svc}.d"
    install "${srcf}" "${dstf}"
}
