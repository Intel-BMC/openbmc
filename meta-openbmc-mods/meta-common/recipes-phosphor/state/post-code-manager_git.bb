SUMMARY = "Phosphor post code manager"
DESCRIPTION = "Post Code Manager"

SRC_URI = "git://github.com/openbmc/phosphor-post-code-manager.git"
SRCREV = "993d4dd9dc583e62a84c6056edffad957d7b7b5d"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

inherit cmake pkgconfig systemd

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.State.Boot.PostCode.service"

DEPENDS += " \
    autoconf-archive-native \
    systemd \
    boost \
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
