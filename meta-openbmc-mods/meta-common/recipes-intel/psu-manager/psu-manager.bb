SUMMARY = "Power supply manager for Intel based platform"
DESCRIPTION = "Power supply manager which include PSU Cold Redundancy service"

SRC_URI = "git://git@github.com/Intel-BMC/provingground.git;protocol=ssh"
SRCREV = "30110fe5b18999bddc5721dc5611f542f6feeabd"

S = "${WORKDIR}/git/psu-manager/"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit cmake
inherit systemd

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.coldredundancy.service"

DEPENDS += " \
    systemd \
    sdbusplus \
    phosphor-dbus-interfaces \
    phosphor-logging \
    boost \
    i2c-tools \
    "
