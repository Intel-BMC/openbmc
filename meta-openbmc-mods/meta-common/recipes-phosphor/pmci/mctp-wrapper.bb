SUMMARY = "MCTP Wrapper Library"
DESCRIPTION = "Implementation of MCTP Wrapper Library"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=bcd9ada3a943f58551867d72893cc9ab"

SRC_URI = "git://github.com/Intel-BMC/pmci.git;protocol=ssh"
SRCREV = "a328510479aad6fd97e958759522ec9bcdc9e8d0"

S = "${WORKDIR}/git/mctp_wrapper"

PV = "1.0+git${SRCPV}"

inherit cmake systemd

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += " \
    libmctp-intel \
    systemd \
    sdbusplus \
    phosphor-logging \
    gtest \
    boost \
    phosphor-dbus-interfaces \
    "

EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"
