SUMMARY = "A stream-oriented XML parser library"
DESCRIPTION = "Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document (like start tags)"
HOMEPAGE = "http://expat.sourceforge.net/"
SECTION = "libs"
LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://COPYING;md5=9e2ce3b3c4c0f2670883a23bbd7c37a9"

VERSION_TAG = "${@d.getVar('PV').replace('.', '_')}"

SRC_URI = "https://github.com/libexpat/libexpat/releases/download/R_${VERSION_TAG}/expat-${PV}.tar.bz2  \
           file://run-ptest \
           file://CVE-2022-40674_1.patch \
           file://CVE-2022-40674_2.patch \
           file://CVE-2022-43680.patch \
           "

UPSTREAM_CHECK_URI = "https://github.com/libexpat/libexpat/releases/"
                      
SRC_URI[sha256sum] = "fbb430f964c7a2db2626452b6769e6a8d5d23593a453ccbc21701b74deabedff"

EXTRA_OECMAKE:class-native += "-DEXPAT_BUILD_DOCS=OFF"

RDEPENDS:${PN}-ptest += "bash"

inherit cmake lib_package ptest

do_install_ptest:class-target() {
	install -m 755 ${B}/tests/* ${D}${PTEST_PATH}
}

BBCLASSEXTEND += "native nativesdk"

CVE_PRODUCT = "expat libexpat"
