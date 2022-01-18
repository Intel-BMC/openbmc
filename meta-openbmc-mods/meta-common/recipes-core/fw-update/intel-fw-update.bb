SUMMARY = "Temporary intel-fw-update script"
DESCRIPTION = "At runtime, perform a firmware update and reboot"
PR = "r1"

# flash_eraseall
RDEPENDS:intel-fw-update += "mtd-utils"
# wget tftp scp
RDEPENDS:intel-fw-update += "busybox dropbear"
# mkfs.vfat, parted
RDEPENDS:intel-fw-update += "dosfstools dtc"

RDEPENDS:intel-fw-update += "bash"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
PFR_EN = "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'pfr', '', d)}"

SRC_URI += "file://fwupd.sh"
SRC_URI += "file://usb-ctrl"

DEPENDS += "obmc-intel-pfr-image-native"

# runtime authentication of some features requires the root key certificate
FILES:${PN} += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '${datadir}/pfr/rk_cert.pem', '', d)}"
PFR_CFG_DIR = "${STAGING_DIR_NATIVE}${datadir}/pfrconfig"

do_install() {
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/fwupd.sh ${D}${bindir}
        install -m 0755 ${WORKDIR}/usb-ctrl ${D}${bindir}

        if [ "${PFR_EN}" = "pfr" ]; then
            install -d ${D}${datadir}/pfr
            install -m 0644 ${PFR_CFG_DIR}/rk_cert.pem ${D}${datadir}/pfr
        fi
}
