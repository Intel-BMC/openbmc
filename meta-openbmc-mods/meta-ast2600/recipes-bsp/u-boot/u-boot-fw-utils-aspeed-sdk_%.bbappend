COMPATIBLE_MACHINE = "intel-ast2600"
FILESEXTRAPATHS_append_intel-ast2600:= "${THISDIR}/files:"

SRC_URI_append_intel-ast2600 = " \
    file://intel.cfg \
    file://0001-Add-ast2600-intel-as-a-new-board.patch \
    file://0003-ast2600-intel-layout-environment-addr.patch \
    "
PFR_SRC_URI = " \
    file://0043-AST2600-PFR-u-boot-env-changes-as-per-PFR-BMC-image.patch \
    "
SRC_URI_append_intel-ast2600 += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', PFR_SRC_URI, '', d)}"

do_install_append () {
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${WORKDIR}/fw_env.config ${S}/tools/env/fw_env.config
}
RDEPENDS_${PN} = "udev-aspeed-mtd-partitions"
