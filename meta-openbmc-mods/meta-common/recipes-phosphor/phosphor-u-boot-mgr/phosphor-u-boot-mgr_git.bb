SUMMARY = "Phosphor U-Boot environment manager"
DESCRIPTION = "Daemon to read or write U-Boot environment variables"

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git/phosphor-u-boot-env-mgr"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://git@github.com/Intel-BMC/provingground.git;protocol=ssh"

SRCREV = "30110fe5b18999bddc5721dc5611f542f6feeabd"

inherit cmake systemd
SYSTEMD_SERVICE_${PN} = "xyz.openbmc_project.U_Boot.Environment.Manager.service"

DEPENDS = "boost sdbusplus phosphor-logging"
