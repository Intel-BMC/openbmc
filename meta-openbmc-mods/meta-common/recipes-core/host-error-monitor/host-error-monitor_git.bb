LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
inherit cmake systemd

SRC_URI = "git://git@github.com/Intel-BMC/at-scale-debug;protocol=ssh"

DEPENDS = "boost sdbusplus libgpiod"

PV = "0.1+git${SRCPV}"
SRCREV = "bf2736cb1c8959164f989f59c4337a0ff108b13f"

S = "${WORKDIR}/git/host_error_monitor"

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.HostErrorMonitor.service"
