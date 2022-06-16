SUMMARY = "MCTP Wrapper Library Plus"
DESCRIPTION = "Implementation of MCTP Wrapper Library Plus"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=615045c30a05cde5c0e924854d43c327"

SRC_URI = "git://git@github.com/Intel-BMC/mctpwplus.git;protocol=ssh;branch=main"
SRCREV = "4a59172db42e6bc55ea00b8c41adb54894a4f9b5"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

inherit cmake

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += " \
    systemd \
    sdbusplus \
    phosphor-logging \
    cli11 \
    "
EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"
