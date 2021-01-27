SUMMARY = "SMBIOS MDR version 1 service for Intel based platform"
DESCRIPTION = "SMBIOS MDR version 1 service for Intel based platfrom"

SRC_URI = "git://github.com/Intel-BMC/provingground.git;protocol=ssh;nobranch=1"
SRCREV = "6aab8bcc8fd0550753c87265036b1b7c4c8a9f71"

S = "${WORKDIR}/git/services/smbios"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit cmake pkgconfig
inherit obmc-phosphor-systemd

SYSTEMD_SERVICE_${PN} += "smbios-mdrv1.service"

DEPENDS += " \
    autoconf-archive-native \
    systemd \
    sdbusplus \
    phosphor-dbus-interfaces \
    phosphor-logging \
    "
RDEPENDS_${PN} += " \
    libsystemd \
    sdbusplus \
    phosphor-dbus-interfaces \
    phosphor-logging \
    "
