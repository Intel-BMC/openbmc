FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI_append = " \
           file://pfr_manifest.json \
           file://pfm_config.xml \
           file://bmc_config.xml \
           file://csk_prv.pem \
           file://csk_pub.pem \
           file://rk_pub.pem \
           file://rk_prv.pem \
          "

do_install_append () {
        install -m 400 ${WORKDIR}/pfr_manifest.json ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/pfm_config.xml ${D}/${datadir}/pfrconfig/pfm_config.xml
        install -m 400 ${WORKDIR}/bmc_config.xml ${D}/${datadir}/pfrconfig/bmc_config.xml
        install -m 400 ${WORKDIR}/csk_prv.pem ${D}/${datadir}/pfrconfig/csk_prv.pem
        install -m 400 ${WORKDIR}/csk_pub.pem ${D}/${datadir}/pfrconfig/csk_pub.pem
        install -m 400 ${WORKDIR}/rk_pub.pem ${D}/${datadir}/pfrconfig/rk_pub.pem
        install -m 400 ${WORKDIR}/rk_prv.pem ${D}/${datadir}/pfrconfig/rk_prv.pem
}

