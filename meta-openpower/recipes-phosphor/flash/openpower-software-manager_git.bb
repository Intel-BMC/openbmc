SUMMARY = "OpenPower Software Management"
DESCRIPTION = "OpenPower Software Manager provides a set of host software \
management daemons. It is suitable for use on a wide variety of OpenPower \
platforms."
HOMEPAGE = "https://github.com/openbmc/openpower-pnor-code-mgmt"
PR = "r1"
PV = "1.0+git${SRCPV}"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit autotools pkgconfig systemd
inherit obmc-phosphor-dbus-service
inherit pythonnative

inherit ${@bb.utils.contains('DISTRO_FEATURES', 'openpower-ubi-fs', \
                             'openpower-software-manager-ubi', \
                             'openpower-software-manager-static', d)}

PACKAGECONFIG[verify_pnor_signature] = "--enable-verify_pnor_signature,--disable-verify_pnor_signature"
PACKAGECONFIG[ubifs_layout] = "--enable-ubifs_layout,--disable-ubifs_layout,,mtd-utils-ubifs"

EXTRA_OECONF += " \
    PNOR_MSL="v2.0.10 v2.2" \
    "

DEPENDS += " \
        autoconf-archive-native \
        phosphor-dbus-interfaces \
        phosphor-logging \
        sdbusplus \
        sdbusplus-native \
        "

RDEPENDS_${PN} += " \
        virtual-obmc-image-manager \
        "

S = "${WORKDIR}/git"

SRC_URI += "git://github.com/openbmc/openpower-pnor-code-mgmt"

SRCREV = "4d3d91262bcaf1afc2eee54145052106644410be"

DBUS_SERVICE_${PN} += "org.open_power.Software.Host.Updater.service"

SYSTEMD_SERVICE_${PN} += " \
        op-pnor-msl.service \
        "
