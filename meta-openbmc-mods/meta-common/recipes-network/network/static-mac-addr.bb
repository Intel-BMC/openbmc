SUMMARY = "Enforce static MAC addresses"
DESCRIPTION = "Set a priority on MAC addresses to run with: \
               factory-specified > u-boot-specified > random"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PV = "1.0"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SRC_URI = "\
    file://mac-check \
    file://${PN}.service \
    "

inherit obmc-phosphor-systemd

SYSTEMD_SERVICE_${PN} += "${PN}.service"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/mac-check ${D}${bindir}
}
