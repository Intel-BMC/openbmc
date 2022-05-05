SUMMARY = "libmctp"
DESCRIPTION = "Implementation of MCTP (DTMF DSP0236)"

SRC_URI = "git://github.com/openbmc/libmctp.git"
SRCREV = "983cc3fa49dcac2e640e814500221c6acc177eff"

PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0 | GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0d30807bb7a4f16d36e96b78f9ed8fae"

inherit cmake

S = "${WORKDIR}/git"

DEPENDS += "i2c-tools"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Smbus-changes-for-libmctp.patch \
            file://0002-Fix-Memory-Leak.patch \
            file://CMakeLists.txt \
            file://crc32c.c \
            file://crc32c.h  \
            file://libmctp-smbus.h  \
            file://smbus.c"

do_configure:prepend() {
    cp -f ${WORKDIR}/*.c ${S}
    cp -f ${WORKDIR}/*.h ${S}
    cp -f ${WORKDIR}/CMakeLists.txt ${S}
}

# linux-libc-headers guides this way to include custom uapi headers
CFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include"
CXXFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include"

do_configure[depends] += "virtual/kernel:do_shared_workdir"

# Copying the depricated header from kernel as a temporary fix to resolve build breaks.
# It should be removed later after fixing the header dependency in this repository.
SRC_URI += "file://asm/rwonce.h"
do_configure:prepend() {
    cp -r ${WORKDIR}/asm ${S}/asm
}
