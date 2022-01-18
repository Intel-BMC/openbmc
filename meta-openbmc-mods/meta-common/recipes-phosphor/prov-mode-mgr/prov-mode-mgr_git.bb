SUMMARY = "Provision mode daemon - RestrictionMode"
DESCRIPTION = "Daemon allows to configure RestrictionMode property"

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://github.com/Intel-BMC/provisioning-mode-manager.git;protocol=ssh"

SRCREV = "0aca01b4ce9b303e12ba0f757f56390da139c8bb"

inherit cmake systemd
SYSTEMD_SERVICE:${PN} = "xyz.openbmc_project.RestrictionMode.Manager.service"

DEPENDS = "boost sdbusplus phosphor-logging"
