SUMMARY = "Temporary intel-fw-update script"
DESCRIPTION = "At runtime, perform a firmware update and reboot"
PR = "r1"

# flash_eraseall
RDEPENDS_intel-fw-update += "mtd-utils"
# wget tftp scp
RDEPENDS_intel-fw-update += "busybox dropbear"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SRC_URI += "file://fwupd.sh"

do_install() {
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/fwupd.sh ${D}${bindir}
}
