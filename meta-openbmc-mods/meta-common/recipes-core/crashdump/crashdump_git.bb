inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-systemd

SUMMARY = "CPU Crashdump"
DESCRIPTION = "CPU utilities for dumping CPU Crashdump and registers over PECI"

DEPENDS = "boost cjson sdbusplus "
inherit cmake

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/Intel-BMC/at-scale-debug;protocol=ssh"
SRCREV = "3369d2e81f7e5e4bcb5d9e14bcecea7ae5da07fb"

S = "${WORKDIR}/git/crashdump"
PACKAGES += "libpeci"

SYSTEMD_SERVICE_${PN} += "com.intel.crashdump.service"
DBUS_SERVICE_${PN} += "com.intel.crashdump.service"

# linux-libc-headers guides this way to include custom uapi headers
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
