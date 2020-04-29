SUMMARY = "One time automatically enable every NIC"
DESCRIPTION = "Re-enable NIC accidentally disabled by earlier BMC firmware."

S = "${WORKDIR}"
SRC_URI = "file://enable-nics.sh \
           file://enable-nics.service \
          "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
RDEPENDS_${PN} += "bash"

inherit systemd

FILES_${PN} += "${systemd_system_unitdir}/enable-nics.service"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/enable-nics.service ${D}${systemd_system_unitdir}
    install -d ${D}${bindir}
    install -m 0755 ${S}/enable-nics.sh ${D}/${bindir}/enable-nics.sh
}

SYSTEMD_SERVICE_${PN} += " enable-nics.service"
