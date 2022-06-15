SUMMARY = "SMBIOS MDR version 2 service for Intel based platform"
DESCRIPTION = "SMBIOS MDR version 2 service for Intel based platfrom"

SRC_URI = "git://github.com/openbmc/smbios-mdr.git"
SRCREV = "473d890ea7fa48e1f3925f085e870dae67d68527"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit cmake pkgconfig
inherit obmc-phosphor-systemd

SYSTEMD_SERVICE:${PN} += "smbios-mdrv2.service"
SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.cpuinfo.service"

DEPENDS += " \
    autoconf-archive-native \
    boost \
    systemd \
    sdbusplus \
    phosphor-dbus-interfaces \
    phosphor-logging \
    libpeci \
    i2c-tools \
    nlohmann-json \
    "

EXTRA_OECMAKE="-DYOCTO=1 -DIPMI_BLOB=0"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'smbios-no-dimm', d)}"
PACKAGECONFIG[smbios-no-dimm] = "-DDIMM_DBUS=OFF, -DDIMM_DBUS=ON"
