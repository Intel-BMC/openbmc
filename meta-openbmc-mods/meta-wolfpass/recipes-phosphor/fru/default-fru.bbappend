
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://checkFruWFP.sh"

do_install_append() {
    # Using an older 'checkFru.sh' file for WFP support.
    install -m 0755 ${S}/checkFruWFP.sh ${D}/${bindir}/checkFru.sh
}

