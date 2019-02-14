SUMMARY = "dtoverlay"
DESCRIPTION = "device tree overlay application"

SRC_URI = "git://github.com/raspberrypi/userland.git"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENCE;md5=0448d6488ef8cc380632b1569ee6d196"

SRCREV = "11389772c79685442e0ab8aa9be8ad0e32703f68"
requires = "chrpath-native"

S = "${WORKDIR}/git"

PV = "1"

inherit cmake

FILES_${PN} += "${libdir} ${libdir}libdtovl.so.${PV}"

do_compile_append(){
	chrpath -d ${S}/build/bin/dtoverlay
}

do_install() {
	install -d ${D}${libdir}
	install -m 0644 ${S}/build/lib/libdtovl.so ${D}${libdir}/libdtovl.so.${PV}
	install -d ${D}${bindir}
	install -m 0755 ${S}/build/bin/dtoverlay ${D}${bindir}/dtoverlay

	ln -sf libdtovl.so.${PV} ${D}{libdir}libdtovl.so
}

