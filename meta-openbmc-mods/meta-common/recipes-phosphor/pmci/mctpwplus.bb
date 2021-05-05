SUMMARY = "MCTP Wrapper Library Plus"
DESCRIPTION = "Implementation of MCTP Wrapper Library Plus"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=615045c30a05cde5c0e924854d43c327"

SRC_URI = "git://github.com/Intel-BMC/pmci.git;protocol=ssh"
SRCREV = "07adfb357cdb679bf9bbcf2eaff7406cfb5fd52b"

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
