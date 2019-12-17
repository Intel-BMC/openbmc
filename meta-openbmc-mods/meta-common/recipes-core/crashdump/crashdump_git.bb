inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-systemd

SUMMARY = "CPU Crashdump"
DESCRIPTION = "CPU utilities for dumping CPU Crashdump and registers over PECI"

DEPENDS = "boost cjson sdbusplus safec gtest libpeci"
inherit cmake

EXTRA_OECMAKE = "-DCRASHDUMP_BUILD_UT=ON"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=26bb6d0733830e7bab774914a8f8f20a"

SRC_URI = "git://github.com/Intel-BMC/crashdump;protocol=git"
SRCREV = "0.4"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE_${PN} += "com.intel.crashdump.service"
DBUS_SERVICE_${PN} += "com.intel.crashdump.service"

# linux-libc-headers guides this way to include custom uapi headers
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
