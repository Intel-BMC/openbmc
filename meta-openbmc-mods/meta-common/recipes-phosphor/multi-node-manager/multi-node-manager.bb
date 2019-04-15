SUMMARY = "Multi node manager"
DESCRIPTION = "Daemon to handle chassis level shared resources on multi-node platform"

SRC_URI = "git://git@github.com/Intel-BMC/multi-node-manager.git;protocol=ssh"
SRCREV = "8a34c017e04dd8f327aff127f64855f6132bd318"

PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SYSTEMD_SERVICE_${PN} = "multi-node-manager.service"

DEPENDS = "boost sdbusplus phosphor-logging i2c-tools"
inherit cmake systemd
