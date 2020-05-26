SUMMARY = "Intel Blocksign tool for PFR image"
DESCRIPTION = "Image signing tool for BMC PFR image"

inherit native cmake

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

DEPENDS = "openssl-native libxml2-native "

SRC_URI = "git://git@github.com/Intel-BMC/blocksign;protocol=ssh"

SRCREV = "852d88a1cbf4dc5856ff88e823a38d2872a86ffe"

S = "${WORKDIR}/git/"

do_install_append() {
   install -d ${D}/${bindir}
   install -m 775 ${B}/blocksign ${D}/${bindir}
}
