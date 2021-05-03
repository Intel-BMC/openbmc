SUMMARY = "libmctp"
DESCRIPTION = "Implementation of MCTP (DTMF DSP0236)"

SRC_URI = "git://github.com/openbmc/libmctp.git"
SRCREV = "eba19a3b122a39ef2b5dbda49b418a202f78a48d"

PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0 | GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0d30807bb7a4f16d36e96b78f9ed8fae"

inherit cmake

S = "${WORKDIR}/git"

DEPENDS += "i2c-tools"

CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Smbus-changes-for-libmctp.patch \
            file://0002-Fix-Memory-Leak.patch \
            file://CMakeLists.txt \
            file://crc32c.c \
            file://crc32c.h  \
            file://libmctp-smbus.h  \
            file://smbus.c"

do_configure_prepend() {
    cp -f ${WORKDIR}/*.c ${S}
    cp -f ${WORKDIR}/*.h ${S}
    cp -f ${WORKDIR}/CMakeLists.txt ${S}
}

# linux-libc-headers guides this way to include custom uapi headers
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"

do_configure[depends] += "virtual/kernel:do_shared_workdir"
