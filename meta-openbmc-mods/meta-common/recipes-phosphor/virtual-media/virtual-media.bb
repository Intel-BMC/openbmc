SUMMARY = "Virtual Media Service"
DESCRIPTION = "Virtual Media Service"

SRC_URI = "git://git@github.com/Intel-BMC/provingground.git;protocol=ssh"
SRCREV = "4aec5d06d6adbaf53dbe7f18ea9f803eb2198b86"

S = "${WORKDIR}/git/virtual-media/"
PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.VirtualMedia.service"

DEPENDS = "udev boost nlohmann-json systemd sdbusplus"

inherit cmake systemd

EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"

FULL_OPTIMIZATION = "-Os -pipe -flto -fno-rtti"
