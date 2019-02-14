DESCRIPTION = "OpenBMC mtd-util"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=b77c43ae4eaf67bd73fb6452b2f113a3"

SRC_URI = "git://git@github.com/Intel-BMC/mtd-util;protocol=ssh"

PV = "1.0+git${SRCPV}"
SRCREV = "22a0216b5e197bb8c7264fd0be0a4bb2d5d25b90"


S = "${WORKDIR}/git"

DEPENDS += "dbus openssl zlib boost microsoft-gsl"

inherit cmake pkgconfig

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = ""

