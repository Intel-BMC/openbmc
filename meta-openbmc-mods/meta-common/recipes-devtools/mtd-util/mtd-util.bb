DESCRIPTION = "OpenBMC mtd-util"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=b77c43ae4eaf67bd73fb6452b2f113a3"

SRC_URI = "git://git@github.com/Intel-BMC/mtd-util.git;protocol=ssh"

PV = "1.0+git${SRCPV}"
SRCREV = "708072b62a3cecb520eeaacac88b4f2c2e101fe4"

SRC_URI += " \
            file://0001-Firmware-update-fix-for-mis-aligned-sectors.patch \
            file://0002-Add-fix-for-possible-freeing-of-mismatched-memory.patch \
            file://0003-Fix-Key-Cancellation-Update-Capsule-Flow.patch \
           "

S = "${WORKDIR}/git"

DEPENDS += "dbus systemd sdbusplus openssl zlib boost microsoft-gsl i2c-tools"

inherit cmake pkgconfig

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = ""

EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '-DDEVELOPER_OPTIONS=ON', '', d)}"
