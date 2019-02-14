SUMMARY = "Phosphor OpenBMC REST framework"
DESCRIPTION = "Phosphor OpenBMC REST to DBUS daemon."
HOMEPAGE = "http://github.com/openbmc/rest-dbus"
PR = "r1"

inherit allarch
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SRC_URI += "git://github.com/openbmc/rest-dbus.git"

SRCREV = "9273a302e8f2b3c3e939dff77758e90f163bf6a1"

S = "${WORKDIR}/git"

FILES_${PN} += "${datadir}/www/rest-dbus/*"

do_install () {
      install -d ${D}${datadir}/www/rest-dbus/res
      install -m 644 ${S}/resources/** ${D}${datadir}/www/rest-dbus/res
      install -m 644 ${S}/resources/index.html  ${D}${datadir}/www/rest-dbus/index.html
}

