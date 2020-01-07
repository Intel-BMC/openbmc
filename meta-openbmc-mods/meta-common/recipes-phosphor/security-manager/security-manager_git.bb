SUMMARY = "Security Manager daemon to detect the security violation- ASD/ user management"
DESCRIPTION = "Daemon check for Remote debug enable and user account violation"

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git/security-manager"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
inherit cmake systemd

SRC_URI = "git://github.com/Intel-BMC/provingground.git;protocol=ssh"
SRCREV = "5a03fdc6a119b65ecf320622ce2809e340749fa9"

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.SecurityManager.service"

DEPENDS += " \
    systemd \
    sdbusplus \
    libgpiod \
    sdbusplus-native \
    phosphor-logging \
    boost \
    "
