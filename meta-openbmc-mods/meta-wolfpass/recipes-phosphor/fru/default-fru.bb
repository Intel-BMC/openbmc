SUMMARY = "Default Fru"
DESCRIPTION = "Installs a default fru file to image"

inherit systemd

SYSTEMD_SERVICE_${PN} = "SetBaseboardFru.service"

S = "${WORKDIR}"
SRC_URI = "file://checkFru.sh \
           file://SetBaseboardFru.service \
           file://*.fru.bin"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENCE;md5=a6a4edad4aed50f39a66d098d74b265b"

RDEPENDS_${PN} = "bash"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/checkFru.sh ${D}/${bindir}/checkFru.sh

    install -d ${D}${sysconfdir}/fru
    cp ${S}/*.fru.bin ${D}/${sysconfdir}/fru

    install -d ${D}${base_libdir}/systemd/system
    install -m 0644 ${S}/SetBaseboardFru.service ${D}${base_libdir}/systemd/system
}
