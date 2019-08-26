SUMMARY = "System watchdog"
DESCRIPTION = "BMC hardware watchdog service that is used to reset BMC \
               when unrecoverable events occurs"

inherit allarch
inherit obmc-phosphor-systemd

RDEPENDS_${PN} = "bash"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SYSTEMD_SERVICE_${PN} += "system-watchdog.service"
SYSTEMD_ENVIRONMENT_FILE_${PN} += "obmc/system-watchdog/system-watchdog.conf"

SYSTEMD_SERVICE_${PN} += "watchdog-reset.service"
SYSTEMD_SERVICE_${PN} += "watchdog-clear-failures.service"
SYSTEMD_SERVICE_${PN} += "watchdog-clear-failures.timer"
SRC_URI += "file://watchdog-reset.sh"

do_install_append(){
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/watchdog-reset.sh ${D}${bindir}
}
