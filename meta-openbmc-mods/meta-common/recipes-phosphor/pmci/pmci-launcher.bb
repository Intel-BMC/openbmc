SUMMARY = "PMCI Launcher"
DESCRIPTION = "Support to launch pmci services on-demand"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://github.com/Intel-BMC/pmci.git;protocol=ssh"
SRCREV = "07adfb357cdb679bf9bbcf2eaff7406cfb5fd52b"

S = "${WORKDIR}/git/pmci_launcher"

PV = "1.0+git${SRCPV}"

inherit cmake systemd

DEPENDS += " \
    systemd \
    sdbusplus \
    phosphor-logging \
    boost \
    "
FILES_${PN} += "${systemd_system_unitdir}/xyz.openbmc_project.pmci-launcher.service"
SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.pmci-launcher.service"
