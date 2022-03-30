SUMMARY = "Intel(R) Platform Firmware Resilience Signing Utility"
DESCRIPTION = "Image signing tool for building Intel(R) PFR image"

inherit cmake native

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

DEPENDS = "openssl-native libxml2-native "

SRC_URI = "git://git@github.com/Intel-BMC/intel-pfr-signing-utility.git;protocol=ssh"

SRCREV = "7ad7cb3f3d7f408fd9ac454c242e77c8fbc6d61b"

S = "${WORKDIR}/git"

do_install:append() {
   install -d ${D}/${bindir}
   install -m 775 ${B}/intel-pfr-signing-utility ${D}/${bindir}
}
