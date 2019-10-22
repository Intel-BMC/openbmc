SUMMARY = "Kernel panic Check"
DESCRIPTION = "script tool to check if the reboot is caused by kernel panic \
               log the kernel panic to systemd journal, and also log to redfish \
              "

S = "${WORKDIR}"
SRC_URI = "file://kernel-panic-check.sh \
           file://kernel-panic-check.service \
"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
RDEPENDS_${PN} += "bash logger-systemd"

inherit systemd

FILES_${PN} += "${systemd_system_unitdir}/kernel-panic-check.service"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/kernel-panic-check.service ${D}${systemd_system_unitdir}
    install -d ${D}${bindir}
    install -m 0755 ${S}/kernel-panic-check.sh ${D}/${bindir}/kernel-panic-check.sh
}

SYSTEMD_SERVICE_${PN} += " kernel-panic-check.service"
