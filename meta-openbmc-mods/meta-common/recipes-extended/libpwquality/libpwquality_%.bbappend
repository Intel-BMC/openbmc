EXTRA_OECONF:append = " --enable-python-bindings=no"
EXTRA_OECONF:append = " --with-securedir=${base_libdir}/security"
FILES:${PN} += "${base_libdir}/security/pam_pwquality.so"
RDEPENDS:${PN}:remove:class-target = " ${PYTHON_PN}-core"
RDEPENDS:${PN}-runtime += "libpwquality"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
        file://pwquality.conf \
        "

do_install:append() {
    install -d ${D}/etc/security
    install -m 0644 ${WORKDIR}/pwquality.conf ${D}/etc/security
}
