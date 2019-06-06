SUMMARY = "SMBIOS MDR version 1 service for Intel based platform"
DESCRIPTION = "SMBIOS MDR version 1 service for Intel based platfrom"

SRC_URI = "git://git@github.com/Intel-BMC/provingground.git;protocol=ssh"
SRCREV = "9d2d365a79591ec21b54ecde957263f1ba1d8391"

S = "${WORKDIR}/git/services/smbios/"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit cmake pkgconfig pythonnative
inherit obmc-phosphor-systemd

SYSTEMD_SERVICE_${PN} += "smbios-mdrv1.service"

DEPENDS += " \
    autoconf-archive-native \
    systemd \
    sdbusplus \
    sdbusplus-native \
    phosphor-dbus-interfaces \
    phosphor-dbus-interfaces-native \
    phosphor-logging \
    "
RDEPENDS_${PN} += " \
    libsystemd \
    sdbusplus \
    phosphor-dbus-interfaces \
    phosphor-logging \
    "
