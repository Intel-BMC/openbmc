SUMMARY = "Intel Blocksign tool for PFR image"
DESCRIPTION = "Image signing tool for BMC PFR image"

inherit native cmake

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

DEPENDS = "openssl-native libxml2-native "

SRC_URI = "git://git@github.com/Intel-BMC/blocksign;protocol=ssh"

SRCREV = "60d76db038a0d85851098b13451246abb0d876ed"

S = "${WORKDIR}/git/"

do_install_append() {
   install -d ${STAGING_DIR}/intel-pfr-files
   install -m 775 ${B}/blocksign ${STAGING_DIR}/intel-pfr-files
}
