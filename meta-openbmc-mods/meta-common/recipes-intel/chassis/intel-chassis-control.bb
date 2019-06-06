SUMMARY = "Chassis Power Control service for Intel based platform"
DESCRIPTION = "Chassis Power Control service for Intel based platfrom"

SRC_URI = "git://git@github.com/Intel-BMC/intel-chassis-control.git;protocol=ssh"
SRCREV = "d98b80a3ce937abe6282b7b9011b47e8b2f162be"

S = "${WORKDIR}/git/services/chassis/"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit cmake systemd

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.Chassis.Control.Power.service"

DEPENDS += " \
    boost \
    i2c-tools \
    libgpiod \
    sdbusplus \
    phosphor-logging \
    "

# linux-libc-headers guides this way to include custom uapi headers
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
