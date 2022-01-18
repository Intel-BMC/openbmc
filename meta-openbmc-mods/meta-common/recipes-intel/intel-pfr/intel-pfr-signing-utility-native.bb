SUMMARY = "Intel(R) Platform Firmware Resilience Signing Utility"
DESCRIPTION = "Image signing tool for building Intel(R) PFR image"

inherit cmake native

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

DEPENDS = "openssl-native libxml2-native "

SRC_URI = "git://github.com/Intel-BMC/intel-pfr-signing-utility;protocol=ssh"

SRCREV = "33b8e02e9b25d5150b744fcbda4cf1e508813194"

S = "${WORKDIR}/git"

do_install:append() {
   install -d ${D}/${bindir}
   install -m 775 ${B}/intel-pfr-signing-utility ${D}/${bindir}
}
