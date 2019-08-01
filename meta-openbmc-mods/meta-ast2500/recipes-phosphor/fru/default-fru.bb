SUMMARY = "Default Fru"
DESCRIPTION = "Installs a default fru file to image"

inherit systemd

SYSTEMD_SERVICE_${PN} = "SetBaseboardFru.service"

S = "${WORKDIR}"
SRC_URI = "file://checkFru.sh \
           file://SetBaseboardFru.service \
           file://create_fru.py"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

RDEPENDS_${PN} = "bash"

python do_compile() {
    import sys
    workdir = d.getVar('WORKDIR', True)
    sys.path.insert(0, workdir)
    from create_fru import create_fru
    create_fru('S2600WFT')
    create_fru('WilsonCity')
    create_fru('WilsonPoint')
    create_fru('M50CYP2SB2U')
    create_fru('D50TNP1SB')
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/checkFru.sh ${D}/${bindir}/checkFru.sh

    install -d ${D}${sysconfdir}/fru
    cp ${S}/*.fru.bin ${D}/${sysconfdir}/fru

    install -d ${D}${base_libdir}/systemd/system
    install -m 0644 ${S}/SetBaseboardFru.service ${D}${base_libdir}/systemd/system
}
