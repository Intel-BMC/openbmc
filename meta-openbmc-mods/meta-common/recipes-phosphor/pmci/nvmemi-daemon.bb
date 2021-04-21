SUMMARY = "NVMe MI Daemon"
DESCRIPTION = "Implementation of NVMe MI daemon"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/Intel-BMC/nvme-mi.git;protocol=ssh;nobranch=1"
SRCREV = "23fad1d6ffd8ccd16b1369b96734a9701fc2802a"
S = "${WORKDIR}/git"
PV = "1.0+git${SRCPV}"

inherit meson systemd

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.nvme-mi.service"
DEPENDS = "boost sdbusplus systemd phosphor-logging mctpwplus googletest"

EXTRA_OEMESON = "-Dyocto_dep='enabled' -Dtests='enabled'"
