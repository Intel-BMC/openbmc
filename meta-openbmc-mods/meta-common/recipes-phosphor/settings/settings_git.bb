SUMMARY = "Settings"

SRC_URI = "git://github.com/Intel-BMC/settings.git;protocol=ssh"
SRCREV = "1a39605ff52db92048df733181eda8fcfe18ce2f"
PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SYSTEMD_SERVICE_${PN} = "xyz.openbmc_project.Settings.service"

DEPENDS = "boost \
           nlohmann-json \
           sdbusplus"

S = "${WORKDIR}/git"
inherit cmake systemd

EXTRA_OECMAKE = "-DYOCTO=1"

