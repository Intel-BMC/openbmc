FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/dbus-sensors.git"
SRCREV = "0b207a624f925460797a51974b77b275d4c05e30"

SRC_URI += "\
    file://intrusionsensor-depend-on-networkd.conf \
    file://0001-Add-check-for-min-max-received-from-hwmon-files.patch \
    file://0002-Fix-PECI-client-creation-flow.patch \
    file://0003-Fix-missing-threshold-de-assert-event-when-threshold.patch \
    file://0004-Fan-Tach-Sensor-Threshold-Ignore-Zero.patch \
    file://0005-Fix-PECI-ioctl-number.patch \
    file://0006-CPUSensor-create-RequirediTempSensor-if-defined.patch \
    file://0007-Add-support-for-the-energy-hwmon-type.patch \
    file://0008-CPUSensor-update-threshold-when-Tcontrol-changes.patch \
    file://0009-CPUSensor-Create-CPUConfig-for-each-PECI-adapter.patch \
    file://0010-Add-support-for-Get-PMBUS-Readings-method.patch \
    file://0011-Fix-for-cpusensor-going-into-D-state.patch \
    file://0012-Serialize-cpusensor-polling.patch \
    file://0013-Add-dummy-cpu-sensor-flag.patch \
    file://0014-Treat-zero-temperatures-readings-as-errors-in-IpmbSe.patch \
    "

DEPENDS:append = " libgpiod libmctp"

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

# Enable Validation unsecure based on IMAGE_FEATURES
EXTRA_OEMESON += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-Dvalidate-unsecure-feature=enabled', '', d)}"

SYSTEMD_SERVICE:${PN} += "${@bb.utils.contains('PACKAGECONFIG', 'nvmesensor', \
                                               'xyz.openbmc_project.nvmesensor.service', \
                                               '', d)}"

do_install:append() {
    svc="xyz.openbmc_project.intrusionsensor.service"
    srcf="${WORKDIR}/intrusionsensor-depend-on-networkd.conf"
    dstf="${D}/etc/systemd/system/${svc}.d/10-depend-on-networkd.conf"
    mkdir -p "${D}/etc/systemd/system/${svc}.d"
    install "${srcf}" "${dstf}"
}
