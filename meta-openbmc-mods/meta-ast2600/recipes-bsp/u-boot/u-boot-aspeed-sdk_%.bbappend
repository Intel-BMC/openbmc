COMPATIBLE_MACHINE = "intel-ast2600"
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files:"

# the meta-phosphor layer adds this patch, which conflicts
# with the intel layout for environment

SRC_URI:append:intel-ast2600 = " \
    file://intel.cfg \
    file://0001-Add-ast2600-intel-as-a-new-board.patch \
    file://0002-AST2600-Enable-host-searial-port-clock-configuration.patch \
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
    file://0016-Add-system-reset-status-support.patch \
    file://0016-Add-LED-control-support.patch \
    file://0017-Manufacturing-mode-physical-presence-detection.patch \
    file://0018-Add-a-workaround-to-cover-VGA-memory-size-bug-in-A0.patch \
    file://0019-Apply-WDT1-2-reset-mask-to-reset-needed-controller.patch \
    file://0022-Reboot-into-UBOOT-on-Watchdog-Failures.patch \
    file://0023-Add-WDT-to-u-boot-to-cover-booting-failures.patch \
    file://0024-fix-SUS_WARN-handling-logic.patch \
    file://0025-ast2600-PFR-platform-EXTRST-reset-mask-selection.patch \
    file://0026-Enable-PCIe-L1-support.patch \
    file://0027-ast2600-Add-Mailbox-init-function.patch \
    file://0028-Improve-randomness-of-mac-address-generation.patch \
    file://0029-Set-UART-routing-in-lowlevel_init.patch \
    file://0030-Add-Aspeed-PWM-uclass-driver.patch \
    file://0031-Add-a-workaround-to-fix-AST2600-A0-booting-issue.patch \
    file://0032-Disable-eSPI-initialization-in-u-boot-for-normal-boo.patch \
    file://0033-Disable-debug-interfaces.patch \
    file://0034-Implement-the-IPMI-commands-in-FFUJ-mode-in-u-boot.patch \
    "

# CVE-2020-10648 vulnerability fix
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files/CVE-2020-10648:"
SRC_URI:append:intel-ast2600 = " \
    file://0001-image-Correct-comment-for-fit_conf_get_node.patch \
    file://0008-image-Load-the-correct-configuration-in-fit_check_si.patch \
    file://0009-fit_check_sign-Allow-selecting-the-configuration-to-.patch \
    file://0012-image-Use-constants-for-required-and-key-name-hint.patch \
    "

# CVE-2019-11059 vulnerability fix
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files/CVE-2019-11059:"
SRC_URI:append:intel-ast2600 = " \
    file://0001-Fix-ext4-block-group-descriptor-sizing.patch \
    "

# CVE-2019-11690 vulnerability fix
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files/CVE-2019-11690:"
SRC_URI:append:intel-ast2600 = " \
    file://0001-lib-uuid-Fix-unseeded-PRNG-on-RANDOM_UUID-y.patch \
    "

# CVE-2019-13105 vulnerability fix
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files/CVE-2019-13105:"
SRC_URI:append:intel-ast2600 = " \
    file://0001-fs-ext4-cache-extent-data.patch \
    file://0002-CVE-2019-13105-ext4-fix-double-free-in-ext4_cache_re.patch \
    "

# CVE-2019-13104 vulnerability fix
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files/CVE-2019-13104:"
SRC_URI:append:intel-ast2600 = " \
    file://0001-CVE-2019-13104-ext4-check-for-underflow-in-ext4fs_re.patch \
    "

# CVE-2019-13106 vulnerability fix
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files/CVE-2019-13106:"
SRC_URI:append:intel-ast2600 = " \
    file://0001-CVE-2019-13106-ext4-fix-out-of-bounds-memset.patch \
    "

# CVE-2021-27097 vulnerability fix
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files/CVE-2021-27097:"
SRC_URI:append:intel-ast2600 = " \
    file://0001-image-Adjust-the-workings-of-fit_check_format.patch \
    file://0002-image-Add-an-option-to-do-a-full-check-of-the-FIT.patch \
    "

# CVE-2021-27138 vulnerability fix
FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files/CVE-2021-27138:"
SRC_URI:append:intel-ast2600 = " \
    file://0001-image-Check-for-unit-addresses-in-FITs.patch \
    "

PFR_SRC_URI = " \
    file://0043-AST2600-PFR-u-boot-env-changes-as-per-PFR-BMC-image.patch \
    "
SRC_URI:append:intel-ast2600 += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', PFR_SRC_URI, '', d)}"

do_install:append () {
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${WORKDIR}/fw_env.config ${S}/tools/env/fw_env.config
}
RDEPENDS:${PN} = "udev-aspeed-mtd-partitions"
