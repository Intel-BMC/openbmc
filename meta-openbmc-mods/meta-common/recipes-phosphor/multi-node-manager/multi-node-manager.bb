SUMMARY = "Multi node manager"
DESCRIPTION = "Daemon to handle chassis level shared resources on multi-node platform"

SRC_URI = "git://github.com/Intel-BMC/multi-node-manager.git;protocol=ssh"
SRCREV = "34d959285a3ca12c4bfefa4040d82d571c78843b"

S = "${WORKDIR}/git/"

PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SYSTEMD_SERVICE_${PN} = "multi-node-manager.service"

DEPENDS = "boost sdbusplus phosphor-logging i2c-tools"
inherit cmake systemd
