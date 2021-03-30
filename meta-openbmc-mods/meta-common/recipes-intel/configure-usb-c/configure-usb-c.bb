SUMMARY = "Configure USB Type C controller"
DESCRIPTION = "Configure USB Type C CC controller which requires basic initialization on every G3 to S5 cycle"

S = "${WORKDIR}"
SRC_URI = " \
   file://configure-usb-c.sh \
   file://configure-usb-c.service \
   "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
RDEPENDS_${PN} += "bash"

inherit systemd

FILES_${PN} += "${systemd_system_unitdir}/configure-usb-c.service"

do_install_append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/configure-usb-c.sh ${D}/${bindir}/configure-usb-c.sh
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/configure-usb-c.service ${D}${base_libdir}/systemd/system
}

SYSTEMD_SERVICE_${PN} = "configure-usb-c.service"
