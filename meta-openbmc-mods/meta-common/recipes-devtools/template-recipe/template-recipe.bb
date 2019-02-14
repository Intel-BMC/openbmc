SUMMARY = "HelloWorld app with phosphor-logging usage example."
DESCRIPTION = "NOTE: Phosphor-logging has dependencies on systemd and sdbusplus."

SRC_URI = "git://git-amr-2.devtools.intel.com:29418/openbmc_template-recipe;protocol=ssh"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "2d5d731254319de8b42d6438b0ce3908dd5b0dec"

S = "${WORKDIR}/git"

inherit cmake

DEPENDS = "systemd sdbusplus phosphor-logging"
RDEPENDS_${PN} = "libsystemd sdbusplus phosphor-logging"
