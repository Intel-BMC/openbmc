SUMMARY = "Phosphor U-Boot environment manager"
DESCRIPTION = "Daemon to read or write U-Boot environment variables"

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/openbmc/phosphor-u-boot-env-mgr.git;protocol=ssh"

SRCREV = "7a36277b6fdf33a554a4f9e2258e39d1696b00c2"

inherit cmake systemd
SYSTEMD_SERVICE_${PN} = "xyz.openbmc_project.U_Boot.Environment.Manager.service"

DEPENDS = "boost sdbusplus phosphor-logging"
