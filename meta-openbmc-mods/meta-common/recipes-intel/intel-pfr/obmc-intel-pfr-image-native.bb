SUMMARY = "Intel PFR image manifest and image signing keys"
DESCRIPTION = "This copies PFR image generation scripts and image signing keys to staging area"

PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit native

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
        bbplain "Copying intel pfr image generation scripts and image signing keys"

        install -d ${D}/${bindir}
        install -d ${D}/${datadir}/pfrconfig
        install -m 775 ${WORKDIR}/pfr_image.py ${D}${bindir}
        install -m 400 ${WORKDIR}/pfr_manifest.json ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/pfm_config.xml ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/bmc_config.xml ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/csk_prv.pem ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/csk_pub.pem ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/rk_pub.pem ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/rk_prv.pem ${D}/${datadir}/pfrconfig
}
