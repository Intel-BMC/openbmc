SUMMARY = "Turn off the ID LED"
DESCRIPTION = "Script to turn off the ID LED after BMC is ready"

S = "${WORKDIR}"
SRC_URI = "file://id-led-off.sh \
           file://id-led-off.service \
          "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
RDEPENDS_${PN} += "bash"

inherit systemd

FILES_${PN} += "${systemd_system_unitdir}/id-led-off.service"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/id-led-off.service ${D}${systemd_system_unitdir}
    install -d ${D}${bindir}
    install -m 0755 ${S}/id-led-off.sh ${D}/${bindir}/id-led-off.sh
}

SYSTEMD_SERVICE_${PN} += " id-led-off.service"
