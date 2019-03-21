inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-systemd

SUMMARY = "CPU Log Utils"
DESCRIPTION = "CPU utilities for dumping CPU registers over PECI"

DEPENDS = "boost cjson sdbusplus "
inherit cmake

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/Intel-BMC/at-scale-debug;protocol=ssh"
SRCREV = "c4c223bdbe5b58a7acad12dc9700365330f2df1c"

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
