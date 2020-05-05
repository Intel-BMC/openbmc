SUMMARY = "Security registers check"
DESCRIPTION = "script tool to check if registers value are security \
               log the security event to systemd journal, and also log to redfish \
              "

S = "${WORKDIR}"
SRC_URI = "file://security-registers-check.sh \
           file://security-registers-check.service \
"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
RDEPENDS_${PN} += "bash logger-systemd"

inherit systemd

FILES_${PN} += "${systemd_system_unitdir}/security-registers-check.service"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/security-registers-check.service ${D}${systemd_system_unitdir}
    install -d ${D}${bindir}
    install -m 0755 ${S}/security-registers-check.sh ${D}/${bindir}/security-registers-check.sh
}

SYSTEMD_SERVICE_${PN} += " security-registers-check.service"
