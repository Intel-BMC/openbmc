SUMMARY = "libpldm_intel"
DESCRIPTION = "Provides encode/decode APIs for PLDM specifications"

SRC_URI = "git://github.com/Intel-BMC/pmci.git;protocol=ssh"
SRCREV = "a328510479aad6fd97e958759522ec9bcdc9e8d0"

S = "${WORKDIR}/git/libpldm_intel"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

inherit cmake

DEPENDS += " \
    gtest \
    "
