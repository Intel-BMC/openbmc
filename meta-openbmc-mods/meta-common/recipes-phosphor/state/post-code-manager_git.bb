SUMMARY = "Phosphor post code manager"
DESCRIPTION = "Post Code Manager"

SRC_URI = "git://github.com/openbmc/phosphor-post-code-manager.git"
SRCREV = "7f50dcaa6feb66cf5307b8a0e4742a36a50eed29"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

inherit cmake pkgconfig systemd

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.State.Boot.PostCode.service"

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
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Implement-post-code-manager.patch"
