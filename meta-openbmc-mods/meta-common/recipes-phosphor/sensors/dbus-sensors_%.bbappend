FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

SRCREV = "0947d7c1cb9dc5ae4bc740d18aff059cb896c309"
#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

SRC_URI += "\
    file://intrusionsensor-depend-on-networkd.conf \
    file://0001-Add-check-for-min-max-received-from-hwmon-files.patch \
    file://0002-Fix-PECI-client-creation-flow.patch \
    file://0003-Fix-missing-threshold-de-assert-event-when-threshold.patch \
    file://0004-Fan-Tach-Sensor-Threshold-Ignore-Zero.patch \
    file://0005-Fix-PECI-ioctl-number.patch \
    "

DEPENDS_append = " libgpiod libmctp"

PACKAGECONFIG += " \
    adcsensor \
    cpusensor \
    exitairtempsensor \
    fansensor \
    hwmontempsensor \
    intrusionsensor \
    ipmbsensor \
    mcutempsensor \
    psusensor \
"

PACKAGECONFIG[nvmesensor] = "-Dnvme=enabled, -Dnvme=disabled"

SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('PACKAGECONFIG', 'nvmesensor', \
                                               'xyz.openbmc_project.nvmesensor.service', \
                                               '', d)}"

do_install_append() {
    svc="xyz.openbmc_project.intrusionsensor.service"
    srcf="${WORKDIR}/intrusionsensor-depend-on-networkd.conf"
    dstf="${D}/etc/systemd/system/${svc}.d/10-depend-on-networkd.conf"
    mkdir -p "${D}/etc/systemd/system/${svc}.d"
    install "${srcf}" "${dstf}"
}
