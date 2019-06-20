# NOTE: LICENSE is being set to "CLOSED" for now.  The PCIe reads over PECI expose
# more information than is accessible from the BIOS or OS, so we need to keep this
# internal to Intel until it's resolved.
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""
inherit cmake systemd

SRC_URI = "git://git@github.com/Intel-BMC/at-scale-debug;protocol=ssh"

DEPENDS = "boost sdbusplus crashdump"

PV = "0.1+git${SRCPV}"
SRCREV = "3369d2e81f7e5e4bcb5d9e14bcecea7ae5da07fb"

S = "${WORKDIR}/git/peci_pcie"

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.PCIe.service"

# linux-libc-headers guides this way to include custom uapi headers
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
