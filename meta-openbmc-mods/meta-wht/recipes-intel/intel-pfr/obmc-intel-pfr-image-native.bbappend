FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI_append = " \
           file://pfr_manifest.json \
           file://pfm_config.xml \
           file://bmc_config.xml \
           file://csk_prv.pem \
           file://csk_pub.pem \
           file://rk_pub.pem \
           file://rk_prv.pem \
           file://pfr_manifest_d.json \
           file://pfm_config_d.xml \
           file://bmc_config_d.xml \
           file://csk_prv_d.pem \
           file://csk_pub_d.pem \
           file://rk_pub_d.pem \
           file://rk_prv_d.pem \
          "

do_install_append () {
        install -m 400 ${WORKDIR}/pfr_manifest.json ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/pfm_config.xml ${D}/${datadir}/pfrconfig/pfm_config.xml
        install -m 400 ${WORKDIR}/bmc_config.xml ${D}/${datadir}/pfrconfig/bmc_config.xml
        install -m 400 ${WORKDIR}/csk_prv.pem ${D}/${datadir}/pfrconfig/csk_prv.pem
        install -m 400 ${WORKDIR}/csk_pub.pem ${D}/${datadir}/pfrconfig/csk_pub.pem
        install -m 400 ${WORKDIR}/rk_pub.pem ${D}/${datadir}/pfrconfig/rk_pub.pem
        install -m 400 ${WORKDIR}/rk_prv.pem ${D}/${datadir}/pfrconfig/rk_prv.pem
        install -m 400 ${WORKDIR}/pfr_manifest_d.json ${D}/${datadir}/pfrconfig/pfr_manifest_d.json
        install -m 400 ${WORKDIR}/pfm_config_d.xml ${D}/${datadir}/pfrconfig/pfm_config_d.xml
        install -m 400 ${WORKDIR}/bmc_config_d.xml ${D}/${datadir}/pfrconfig/bmc_config_d.xml
        install -m 400 ${WORKDIR}/csk_prv_d.pem ${D}/${datadir}/pfrconfig/csk_prv_d.pem
        install -m 400 ${WORKDIR}/csk_pub_d.pem ${D}/${datadir}/pfrconfig/csk_pub_d.pem
        install -m 400 ${WORKDIR}/rk_pub_d.pem ${D}/${datadir}/pfrconfig/rk_pub_d.pem
        install -m 400 ${WORKDIR}/rk_prv_d.pem ${D}/${datadir}/pfrconfig/rk_prv_d.pem

}

