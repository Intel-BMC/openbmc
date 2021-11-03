SUMMARY = "Default Fru"
DESCRIPTION = "Builds a default FRU file at runtime based on board ID"

inherit obmc-phosphor-systemd
inherit cmake

SRC_URI = "file://checkFru.sh;subdir=${BP} \
           file://decodeBoardID.sh;subdir=${BP} \
           file://mkfru.cpp;subdir=${BP} \
           file://CMakeLists.txt;subdir=${BP} \
           "
SYSTEMD_SERVICE:${PN} = "SetBaseboardFru.service"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "\
    file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658 \
    file://mkfru.cpp;beginline=2;endline=14;md5=c451359f18a13ee69602afce1588c01a \
    "

RDEPENDS:${PN} = "bash"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/checkFru.sh ${D}${bindir}/checkFru.sh
    install -m 0755 ${S}/decodeBoardID.sh ${D}${bindir}/decodeBoardID.sh
}
