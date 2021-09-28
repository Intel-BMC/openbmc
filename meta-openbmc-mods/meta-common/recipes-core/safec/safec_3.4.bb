SUMMARY  = "Safe C Library"

LICENSE  = "safec"
LIC_FILES_CHKSUM = "file://COPYING;md5=6d0eb7dfc57806a006fcbc4e389cf164"
SECTION = "lib"

inherit autotools pkgconfig

S = "${WORKDIR}/git"
SRCREV = "bfc9f8bb8a9bfd02fde8ef3fd78fcd61411d070d"
SRC_URI = "git://github.com/rurban/safeclib.git"

COMPATIBLE_HOST = '(x86_64|i.86|powerpc|powerpc64|arm|aarch64).*-linux'

RDEPENDS:${PN} = "perl"
