SUMMARY  = "Safe C Library"

LICENSE  = "safec"
LIC_FILES_CHKSUM = "file://COPYING;md5=6d0eb7dfc57806a006fcbc4e389cf164"
SECTION = "lib"

inherit autotools pkgconfig

S = "${WORKDIR}/git"
SRCREV = "a4abce065446410d137cece7cd017ff80251713d"
SRC_URI = "git://github.com/rurban/safeclib.git"

COMPATIBLE_HOST = '(x86_64|i.86|powerpc|powerpc64|arm|aarch64).*-linux'

RDEPENDS_${PN} = "perl"
