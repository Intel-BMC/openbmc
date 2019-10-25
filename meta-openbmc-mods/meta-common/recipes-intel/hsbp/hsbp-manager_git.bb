SUMMARY = "HSBP Manager"
DESCRIPTION = "HSBP Manager monitors HSBPs through SMBUS"

SRC_URI = "git://git@github.com/Intel-BMC/provingground.git;protocol=ssh"
SRCREV = "30110fe5b18999bddc5721dc5611f542f6feeabd"
PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SYSTEMD_SERVICE_${PN} = "hsbp-manager.service"

DEPENDS = "boost \
           i2c-tools \
           sdbusplus"

S = "${WORKDIR}/git/hsbp-manager"
inherit cmake systemd

EXTRA_OECMAKE = "-DYOCTO=1"

