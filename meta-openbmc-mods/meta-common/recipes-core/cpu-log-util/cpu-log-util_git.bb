inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-systemd

SUMMARY = "CPU Log Utils"
DESCRIPTION = "CPU utilities for dumping CPU registers over PECI"

DEPENDS = "boost cjson sdbusplus "
inherit cmake

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/Intel-BMC/at-scale-debug;protocol=ssh"
SRCREV = "71a38355f46ee52620be7304c3712a47c00dad1e"

S = "${WORKDIR}/git/cpu-log-util"
PACKAGES += "libpeci"

SYSTEMD_SERVICE_${PN} += "com.intel.CpuDebugLog.service"
DBUS_SERVICE_${PN} += "com.intel.CpuDebugLog.service"

# linux-libc-headers guides this way to include custom uapi headers
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
