SUMMARY = "logger tool in util-linux with systemd support"
HOMEPAGE = "http://userweb.kernel.org/~kzak/util-linux/"
DESCRIPTION = "logger tool with systemd support, used to add log to systemd journald."

SECTION = "base"

LICENSE = "GPLv2+ & LGPLv2.1+ & BSD-3-Clause & BSD-4-Clause"

LIC_FILES_CHKSUM = "file://README.licensing;md5=972a134f1e14b2b060e365df2fab0099 \
                    file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://Documentation/licenses/COPYING.GPL-2.0-or-later;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://Documentation/licenses/COPYING.LGPL-2.1-or-later;md5=4fbd65380cdd255951079008b364516c \
                    file://Documentation/licenses/COPYING.BSD-3-Clause;md5=58dcd8452651fc8b07d1f65ce07ca8af \
                    file://Documentation/licenses/COPYING.BSD-4-Clause-UC;md5=263860f8968d8bafa5392cab74285262 \
                    file://libuuid/COPYING;md5=6d2cafc999feb2c2de84d4d24b23290c \
                    file://libmount/COPYING;md5=7c7e39fb7d70ffe5d693a643e29987c2 \
                    file://libblkid/COPYING;md5=693bcbbe16d3a4a4b37bc906bc01cc04"

inherit autotools gettext pkgconfig
DEPENDS = "libcap-ng ncurses virtual/crypt zlib systemd "
#DEPENDS_intel-ast2500 += " systemd "
#RDEPENDS_${PN} += " libsystemd"

MAJOR_VERSION = "${@'.'.join(d.getVar('PV').split('.')[0:2])}"
SRC_URI = "${KERNELORG_MIRROR}/linux/utils/util-linux/v${MAJOR_VERSION}/util-linux-${MAJOR_VERSION}.tar.xz \
           "

S = "${WORKDIR}/util-linux-${MAJOR_VERSION}"

EXTRA_OECONF = " --disable-nls --disable-all-programs  \
    --disable-libuuid --disable-libblkid --disable-libmount \
    --disable-libsmartcols --disable-libfdisk --disable-pylibmount \
    --with-systemd \
    --enable-logger \
    "

do_install_append () {
    mv ${D}${bindir}/logger ${D}${bindir}/logger-systemd
    rm -rf ${D}${sbindir}
    rm -rf ${D}${base_libdir}
    rm -rf ${D}${libdir}
    rm -rf ${D}${datadir}
}
