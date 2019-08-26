SUMMARY = "Chassis Power Control service for Intel based platform"
DESCRIPTION = "Chassis Power Control service for Intel based platfrom"

SRC_URI = "git://git@github.com/Intel-BMC/intel-chassis-control.git;protocol=ssh"
SRCREV = "a9441965b7b1065bb8a803da9e5c230d3b90f495"

S = "${WORKDIR}/git/services/chassis/"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit cmake systemd

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.Chassis.Control.Power.service"

DEPENDS += " \
    boost \
    i2c-tools \
    libgpiod \
    sdbusplus \
    phosphor-logging \
    "
