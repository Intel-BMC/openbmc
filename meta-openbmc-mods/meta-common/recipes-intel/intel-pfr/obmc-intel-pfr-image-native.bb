SUMMARY = "Intel PFR manifest and signing key for development and testing"
DESCRIPTION = "Do not use this signing keys to sign CI and release images."

PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit native

PFR_KEY_NAME ?= "pfr-dev-key"
PFR_SIGN_UTIL ?= "blocksign"
DEPENDS += " intel-blocksign-native"

SRC_URI = " \
           file://pfr_manifest.json \
           file://pfr_image.py \
           file://pfm_config.xml \
           file://bmc_config.xml \
           file://csk_prv.pem \
           file://csk_pub.pem \
           file://rk_pub.pem \
           file://rk_prv.pem \
          "

do_install() {
        bbplain "Copying the intel pfr image generation scripts and image signing keys"

        install -d ${STAGING_DIR}/intel-pfr-files
        install -m 400 ${WORKDIR}/pfr_manifest.json ${STAGING_DIR}/intel-pfr-files
        install -m 400 ${WORKDIR}/pfm_config.xml ${STAGING_DIR}/intel-pfr-files
        install -m 400 ${WORKDIR}/bmc_config.xml  ${STAGING_DIR}/intel-pfr-files
        install -m 775 ${WORKDIR}/pfr_image.py ${STAGING_DIR}/intel-pfr-files
        install -m 400 ${WORKDIR}/csk_prv.pem ${STAGING_DIR}/intel-pfr-files
        install -m 400 ${WORKDIR}/csk_pub.pem ${STAGING_DIR}/intel-pfr-files
        install -m 400 ${WORKDIR}/rk_pub.pem ${STAGING_DIR}/intel-pfr-files
        install -m 400 ${WORKDIR}/rk_prv.pem ${STAGING_DIR}/intel-pfr-files
}
