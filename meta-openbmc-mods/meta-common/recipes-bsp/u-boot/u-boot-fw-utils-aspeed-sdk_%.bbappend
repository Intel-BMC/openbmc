FILESEXTRAPATHS_append_intel-ast2600:= "${THISDIR}/files:"

SRC_URI_append_intel-ast2600 = " \
    file://fw_env.config \
    file://intel.cfg \
    file://0001-Add-ast2600-intel-as-a-new-board.patch \
    file://0003-ast2600-intel-layout-environment-addr.patch \
    "

do_install_append () {
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${WORKDIR}/fw_env.config ${S}/tools/env/fw_env.config
}
RDEPENDS_${PN} = "udev-aspeed-mtd-partitions"
