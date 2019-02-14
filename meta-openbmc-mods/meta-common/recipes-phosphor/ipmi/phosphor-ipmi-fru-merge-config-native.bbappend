FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " file://config.yaml"

#override source file before it is used for final FRU file (merged from multiple sources)
do_install() {
  cp ${WORKDIR}/config.yaml ${config_datadir}/
}

