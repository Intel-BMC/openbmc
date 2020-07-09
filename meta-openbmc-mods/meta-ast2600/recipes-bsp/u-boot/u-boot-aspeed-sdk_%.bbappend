COMPATIBLE_MACHINE = "intel-ast2600"
FILESEXTRAPATHS_append_intel-ast2600:= "${THISDIR}/files:"

# the meta-phosphor layer adds this patch, which conflicts
# with the intel layout for environment

SRC_URI_append_intel-ast2600 = " \
    file://intel.cfg \
    file://0001-Add-ast2600-intel-as-a-new-board.patch \
    file://0021-AST2600-Enable-host-searial-port-clock-configuration.patch \
    file://0003-ast2600-intel-layout-environment-addr.patch \
    file://0004-AST2600-Adjust-default-GPIO-settings.patch \
    file://0005-Ast2600-Enable-interrupt-in-u-boot.patch \
    file://0006-SPI-Quad-IO-Mode.patch \
    file://0007-ast2600-Override-OTP-strap-settings.patch \
    file://0008-AST2600-Add-TPM-pulse-trigger.patch \
    file://0009-AST2600-Disable-DMA-arbitration-options-on-MAC1-and-.patch \
    file://0010-Fix-timer-support.patch \
    file://0011-KCS-driver-support-in-uBoot.patch \
    file://0012-IPMI-command-handler-implementation-in-uboot.patch \
    file://0013-Add-a-workaround-to-cover-UART-interrupt-bug-in-AST2.patch \
    file://0014-Add-a-workaround-to-cover-eSPI-OOB-free-bug-in-AST26.patch \
    file://0015-net-phy-realtek-Change-LED-configuration.patch \
    "

PFR_SRC_URI = " \
    file://0043-AST2600-PFR-u-boot-env-changes-as-per-PFR-BMC-image.patch \
    "
SRC_URI_append_intel-ast2600 += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', PFR_SRC_URI, '', d)}"

do_install_append () {
    install -m 0644 ${WORKDIR}/fw_env.config ${S}/tools/env/fw_env.config
}
