SUMMARY = "MCTP Daemon"
DESCRIPTION = "Implementation of MCTP (DTMF DSP0236)"

LICENSE = "Apache-2.0 | GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://github.com/Intel-BMC/pmci.git;protocol=ssh"
SRCREV = "df5eba0d1ea5a1e07d24eca95cc9ce5d25819c69"

S = "${WORKDIR}/git/mctpd/"

PV = "1.0+git${SRCPV}"

inherit cmake systemd

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += " \
    libmctp \
    systemd \
    sdbusplus \
    phosphor-logging \
    boost \
    i2c-tools \
    "
SYSTEMD_SERVICE_${PN} = "xyz.openbmc_project.mctpd.service"
