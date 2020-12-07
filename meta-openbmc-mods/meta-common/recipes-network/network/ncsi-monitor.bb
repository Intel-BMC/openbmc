SUMMARY = "Check for host in reset to disable the NCSI iface"
DESCRIPTION = "If the host is in reset, the NCSI NIC will not be \
               available, so this will manually disable the NIC"

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

PV = "1.0"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SRC_URI = "\
    file://check-for-host-in-reset \
    file://${BPN}.service \
    "

inherit obmc-phosphor-systemd

SYSTEMD_SERVICE_${PN} += "${BPN}.service"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/check-for-host-in-reset ${D}/${bindir}/check-for-host-in-reset

}
