SUMMARY = "Default Fru"
DESCRIPTION = "Builds a default FRU file at runtime based on board ID"

inherit systemd
inherit cmake

SYSTEMD_SERVICE_${PN} = "SetBaseboardFru.service"

S = "${WORKDIR}"
SRC_URI = "file://checkFru.sh \
           file://decodeBoardID.sh \
           file://SetBaseboardFru.service \
           file://mkfru.cpp \
           file://CMakeLists.txt \
           "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "\
    file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658 \
    file://mkfru.cpp;beginline=2;endline=14;md5=c451359f18a13ee69602afce1588c01a \
    "

RDEPENDS_${PN} = "bash"

do_install_append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/checkFru.sh ${D}/${bindir}/checkFru.sh
    install -m 0755 ${S}/decodeBoardID.sh ${D}/${bindir}/decodeBoardID.sh

    install -d ${D}${base_libdir}/systemd/system
    install -m 0644 ${S}/SetBaseboardFru.service ${D}${base_libdir}/systemd/system
}
