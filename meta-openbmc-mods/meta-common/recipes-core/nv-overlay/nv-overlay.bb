SUMMARY = "Limited NV overlay init script"
DESCRIPTION = "At runtime, overlay a few directories with an NV COW"
PR = "r1"

inherit obmc-phosphor-systemd

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SRC_URI += "file://nv-overlay.sh"
SRC_URI += "file://nv-overlay.service"

do_install_append() {
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/nv-overlay.sh ${D}${bindir}
}

TMPL = "nv-overlay.service"
SYSTEMD_SERVICE_${PN} += "${TMPL}"
