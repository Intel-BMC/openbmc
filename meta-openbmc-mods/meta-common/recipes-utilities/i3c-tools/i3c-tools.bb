SUMMARY = "i3c-tools"
DESCRIPTION = "Set of tools to interact with i3c devices from user space"

SRC_URI = "git://github.com/vitor-soares-snps/i3c-tools.git"
SRCREV = "5d752038c72af8e011a2cf988b1476872206e706"

S = "${WORKDIR}/git"

PV = "0.1+git${SRCPV}"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "\
    file://i3ctransfer.c;beginline=1;endline=6;md5=8a1ae5c1aaf128e640de497ceaa9935e \
    "

inherit cmake

SRC_URI += "\
    file://CMakeLists.txt \
    "

do_configure:prepend() {
    cp -f ${WORKDIR}/CMakeLists.txt ${S}
}

