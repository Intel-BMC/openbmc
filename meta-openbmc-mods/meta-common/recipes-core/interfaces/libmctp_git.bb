SUMMARY = "libmctp"
DESCRIPTION = "Implementation of MCTP (DTMF DSP0236)"

SRC_URI = "git://github.com/openbmc/libmctp.git"
SRCREV = "195a7c5e212f7fb50c850880519073ec99133607"

PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0 | GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0d30807bb7a4f16d36e96b78f9ed8fae"

inherit cmake

S = "${WORKDIR}/git"

DEPENDS = "i2c-tools"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-smbus-support-to-Cmake-Lists.patch \
            file://crc32c.c \
            file://crc32c.h  \
            file://libmctp-smbus.h  \
            file://smbus.c"

do_configure_prepend() {
    cp -f ${WORKDIR}/*.c ${S}
    cp -f ${WORKDIR}/*.h ${S}
}

