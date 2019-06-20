SUMMARY = "Settings"

SRC_URI = "git://git-amr-2.devtools.intel.com:29418/openbmc-provingground.git;protocol=ssh"
SRCREV = "4373d99e1edcbb4c7233abde3a5e53690693007b"
PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SYSTEMD_SERVICE_${PN} = "settings.service"

DEPENDS = "boost \
           nlohmann-json \
           sdbusplus"

S = "${WORKDIR}/git/settings"
inherit cmake systemd

EXTRA_OECMAKE = "-DYOCTO=1"

