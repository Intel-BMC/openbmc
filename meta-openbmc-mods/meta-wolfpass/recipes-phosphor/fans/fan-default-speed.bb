SUMMARY = "Set Wolfpass fan default speeds"
DESCRIPTION = "Sets all fans to a single speed"

inherit allarch
inherit obmc-phosphor-systemd

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

RDEPENDS_${PN} += "python"

S = "${WORKDIR}"
SRC_URI += "file://set_fan_speeds.py"

SYSTEMD_SERVICE_${PN} += "fan-default-speed.service"

do_install() {
        install -d ${D}/${bindir}
        install -m 0755 ${WORKDIR}/set_fan_speeds.py ${D}/${bindir}/set_fan_speeds.py
}
