# Add GSL: Guideline Support Library for c++
# https://github.com/Microsoft/GSL

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=363055e71e77071107ba2bb9a54bd9a7"

SRC_URI = "git://github.com/Microsoft/GSL.git;protocol=https;nobranch=1"

# Modify these as desired
PV = "1.0+git${SRCPV}"
#SRCREV = "${AUTOREV}"
SRCREV = "be43c79742dc36ee55b21c5d531a5ff301d0ef8d"

S = "${WORKDIR}/git"

do_install () {
    install -d ${D}/usr/include
    install -d ${D}/usr/include/gsl
    for F in ${S}/include/gsl/*; do
        install -m 0644 ${F} ${D}/usr/include/gsl
    done
}

ALLOW_EMPTY_${PN} = "1"
