SUMMARY = "MCTP Daemon"
DESCRIPTION = "Implementation of MCTP (DTMF DSP0236)"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://github.com/Intel-BMC/pmci.git;protocol=ssh"
SRCREV = "626ae6b67b1e2c53e25c0be0b42561c6776be1c7"

S = "${WORKDIR}/git/mctpd/"

PV = "1.0+git${SRCPV}"

inherit cmake systemd

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += " \
    libmctp-intel \
    systemd \
    sdbusplus \
    phosphor-logging \
    boost \
    i2c-tools \
    cli11 \
    nlohmann-json \
    gtest \
    phosphor-dbus-interfaces \
    "
SMBUS_BINDING = "smbus"

FILES_${PN} += "${systemd_system_unitdir}/xyz.openbmc_project.mctpd@.service"
SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.mctpd@${SMBUS_BINDING}.service"
FILES_${PN} += "/usr/share/mctp/mctp_config.json"
