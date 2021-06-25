SUMMARY = "MCTP Wrapper Library Plus"
DESCRIPTION = "Implementation of MCTP Wrapper Library Plus"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=615045c30a05cde5c0e924854d43c327"

SRC_URI = "git://github.com/Intel-BMC/pmci.git;protocol=ssh"
SRCREV = "5ee1b657ccfc61f4dac4a4d59da62a781065b0ad"

S = "${WORKDIR}/git/mctpwplus"

PV = "1.0+git${SRCPV}"

inherit cmake

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += " \
    systemd \
    sdbusplus \
    phosphor-logging \
    cli11 \
    "
EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"
