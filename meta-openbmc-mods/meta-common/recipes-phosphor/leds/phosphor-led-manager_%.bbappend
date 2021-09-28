FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RDEPENDS:${PN}:remove = "clear-once"

do_compile:prepend(){
     install -m 0644 ${STAGING_DATADIR_NATIVE}/${PN}/led.yaml ${S}
}

do_install:append(){
    rm -f ${S}/led.yaml
}


