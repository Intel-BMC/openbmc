DESCRIPTION = "OpenBMC mtd-util"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=b77c43ae4eaf67bd73fb6452b2f113a3"

SRC_URI = "git://github.com/Intel-BMC/mtd-util;protocol=ssh"

PV = "1.0+git${SRCPV}"
SRCREV = "166634ae4677a2a4bcaa99717eb522ce68e9b3d4"


S = "${WORKDIR}/git"

DEPENDS += "dbus openssl zlib boost microsoft-gsl"

inherit cmake pkgconfig

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = ""

EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '-DDEVELOPER_OPTIONS=ON', '', d)}"
