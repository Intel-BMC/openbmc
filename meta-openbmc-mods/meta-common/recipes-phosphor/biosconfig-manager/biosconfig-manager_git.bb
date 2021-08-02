SUMMARY = "BIOS Config Manager daemon for managing the BIOS configuration"
DESCRIPTION = "To view and modify BIOS setup configuration remotely via BMC"

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
inherit meson systemd

SRC_URI = "git://github.com/openbmc/bios-settings-mgr.git"
SRCREV = "5e2cb7206e695662f09c7cb4e0c73ba11686acaa"

SYSTEMD_SERVICE_${PN} += " \
        xyz.openbmc_project.biosconfig_manager.service \
        xyz.openbmc_project.biosconfig_password.service \
        "

DEPENDS += " \
    systemd \
    sdbusplus \
    libgpiod \
    phosphor-logging \
    boost \
    nlohmann-json \
    libtinyxml2 \
    "
