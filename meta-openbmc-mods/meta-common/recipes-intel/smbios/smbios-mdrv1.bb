SUMMARY = "SMBIOS MDR version 1 service for Intel based platform"
DESCRIPTION = "SMBIOS MDR version 1 service for Intel based platfrom"

SRC_URI = "git://git@github.com/Intel-BMC/provingground.git;protocol=ssh"
SRCREV = "4aec5d06d6adbaf53dbe7f18ea9f803eb2198b86"

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
