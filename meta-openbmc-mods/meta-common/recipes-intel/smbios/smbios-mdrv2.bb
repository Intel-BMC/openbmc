SUMMARY = "SMBIOS MDR version 2 service for Intel based platform"
DESCRIPTION = "SMBIOS MDR version 2 service for Intel based platfrom"

SRC_URI = "git://git@github.com/Intel-BMC/provingground.git;protocol=ssh"
SRCREV = "3cc86d6c536b4c5ee7afb5447837b83ce8b3d149"

S = "${WORKDIR}/git/services/smbios-mdrv2/"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit cmake pkgconfig pythonnative
inherit obmc-phosphor-systemd

SYSTEMD_SERVICE_${PN} += "smbios-mdrv2.service"

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
