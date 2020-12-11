SUMMARY = "Power supply manager for Intel based platform"
DESCRIPTION = "Power supply manager which include PSU Cold Redundancy service"

SRC_URI = "git://github.com/Intel-BMC/psu-manager.git;protocol=ssh"
SRCREV = "a6dcc49f7513789931099be7948ba5b6a39e9c20"

S = "${WORKDIR}/git"

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
