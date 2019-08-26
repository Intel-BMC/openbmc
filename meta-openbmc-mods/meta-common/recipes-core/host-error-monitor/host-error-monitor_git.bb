LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
inherit cmake systemd

SRC_URI = "git://git@github.com/Intel-BMC/provingground.git;protocol=ssh;nobranch=1"

DEPENDS = "boost sdbusplus libgpiod crashdump"

PV = "0.1+git${SRCPV}"
SRCREV = "dd93b578f1b193cb08f46e7fced6efdeb38dcc96"

S = "${WORKDIR}/git/host_error_monitor"

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.HostErrorMonitor.service"

# linux-libc-headers guides this way to include custom uapi headers
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
