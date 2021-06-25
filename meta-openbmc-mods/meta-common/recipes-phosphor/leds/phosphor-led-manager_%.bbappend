FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN}_remove = "clear-once"

do_compile_prepend(){
     install -m 0644 ${STAGING_DATADIR_NATIVE}/${PN}/led.yaml ${S}
}

do_install_append(){
    rm -f ${S}/led.yaml
}


