SUMMARY = "PLDM Requester Stack"
DESCRIPTION = "Implementation of PLDM specifications"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI += "git://github.com/Intel-BMC/pmci.git;protocol=ssh"
SRCREV = "07adfb357cdb679bf9bbcf2eaff7406cfb5fd52b"

S = "${WORKDIR}/git/pldmd"

PV = "1.0+git${SRCPV}"

inherit cmake systemd

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

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

FILES_${PN} += "${systemd_system_unitdir}/xyz.openbmc_project.pldmd.service"
SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.pldmd.service"
