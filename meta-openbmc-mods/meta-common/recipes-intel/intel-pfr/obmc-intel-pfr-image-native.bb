SUMMARY = "Intel PFR image manifest and image signing keys"
DESCRIPTION = "This copies PFR image generation scripts and image signing keys to staging area"

PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit native

DEPENDS += " intel-blocksign-native"

SRC_URI = " \
           file://pfr_image.py \
           file://${PRODUCT_GENERATION}/pfr_manifest.json \
           file://${PRODUCT_GENERATION}/pfm_config.xml \
           file://${PRODUCT_GENERATION}/bmc_config.xml \
           file://${PRODUCT_GENERATION}/csk_prv.pem \
           file://${PRODUCT_GENERATION}/csk_pub.pem \
           file://${PRODUCT_GENERATION}/rk_pub.pem \
           file://${PRODUCT_GENERATION}/rk_prv.pem \
          "

do_install () {
        bbplain "Copying intel pfr image generation scripts and image signing keys"

        install -d ${D}${bindir}
        install -d ${D}/${datadir}/pfrconfig
        install -m 775 ${WORKDIR}/pfr_image.py ${D}${bindir}/pfr_image.py
        install -m 400 ${WORKDIR}/${PRODUCT_GENERATION}/pfr_manifest.json ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/${PRODUCT_GENERATION}/pfm_config.xml ${D}/${datadir}/pfrconfig/pfm_config.xml
        install -m 400 ${WORKDIR}/${PRODUCT_GENERATION}/bmc_config.xml ${D}/${datadir}/pfrconfig/bmc_config.xml
        install -m 400 ${WORKDIR}/${PRODUCT_GENERATION}/csk_prv.pem ${D}/${datadir}/pfrconfig/csk_prv.pem
        install -m 400 ${WORKDIR}/${PRODUCT_GENERATION}/csk_pub.pem ${D}/${datadir}/pfrconfig/csk_pub.pem
        install -m 400 ${WORKDIR}/${PRODUCT_GENERATION}/rk_pub.pem ${D}/${datadir}/pfrconfig/rk_pub.pem
        install -m 400 ${WORKDIR}/${PRODUCT_GENERATION}/rk_prv.pem ${D}/${datadir}/pfrconfig/rk_prv.pem
}

