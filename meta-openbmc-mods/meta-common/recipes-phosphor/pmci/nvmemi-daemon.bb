SUMMARY = "NVMe MI Daemon"
DESCRIPTION = "Implementation of NVMe MI daemon"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/Intel-BMC/nvme-mi.git;protocol=ssh"
SRCREV = "63e1cf7f8b950d37fdb035745bf740ec87ede6ae"
S = "${WORKDIR}/git"
PV = "1.0+git${SRCPV}"

inherit meson systemd

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.nvme-mi.service"
DEPENDS = "boost sdbusplus systemd phosphor-logging mctpwplus googletest nlohmann-json"

EXTRA_OEMESON = "-Dyocto_dep='enabled' -Dtests='enabled'"
