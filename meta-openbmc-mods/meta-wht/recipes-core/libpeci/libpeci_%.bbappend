FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI += "file://99-peci.rules"

do_install_append() {
    install -d ${D}/lib/udev/rules.d
    install -m 0644 ${WORKDIR}/99-peci.rules ${D}/lib/udev/rules.d
}
