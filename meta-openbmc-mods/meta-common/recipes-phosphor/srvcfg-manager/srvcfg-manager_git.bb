SUMMARY = "Service configuration manager daemon to control service properties"
DESCRIPTION = "Daemon controls service properies like port, channels, state etc.."

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git/srvcfg-manager"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://github.com/Intel-BMC/provingground.git;protocol=ssh"
SRCREV = "5a03fdc6a119b65ecf320622ce2809e340749fa9"

inherit cmake systemd
SYSTEMD_SERVICE_${PN} = "srvcfg-manager.service"

DEPENDS += " \
    systemd \
    sdbusplus \
    sdbusplus-native \
    phosphor-logging \
    boost \
    "
RDEPENDS_${PN} += " \
    libsystemd \
    sdbusplus \
    phosphor-logging \
    "
