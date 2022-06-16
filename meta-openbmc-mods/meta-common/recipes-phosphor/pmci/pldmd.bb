SUMMARY = "PLDM Requester Stack"
DESCRIPTION = "Implementation of PLDM specifications"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI += "git://git@github.com/Intel-BMC/pldmd.git;protocol=ssh;branch=1-release"
SRCREV = "dd493b97dd7b243738e2d00c983a82a8a6d05db0"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

inherit cmake systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += " \
    libpldm-intel \
    mctp-wrapper \
    systemd \
    sdbusplus \
    phosphor-logging \
    gtest \
    boost \
    phosphor-dbus-interfaces \
    mctpwplus \
    "

FILES:${PN} += "${systemd_system_unitdir}/xyz.openbmc_project.pldmd.service"
SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.pldmd.service"
