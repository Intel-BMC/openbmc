COMPATIBLE_MACHINE = "intel-ast2500"
FILESEXTRAPATHS_append_intel-ast2500:= "${THISDIR}/files:"
FILESEXTRAPATHS_append_intel-ast2500:= "${THISDIR}/files/CVE-2020-10648:"

# the meta-phosphor layer adds this patch, which conflicts
# with the intel layout for environment
SRC_URI_remove_intel-ast2500 = " file://0001-configs-ast-Add-redundnant-env.patch"

SRC_URI_append_intel-ast2500 = " \
    file://intel.cfg \
    file://0001-flash-use-readX-writeX-not-udelay.patch \
    file://0002-intel-layout-environment-addr.patch \
    file://0004-Make-sure-debug-uart-is-using-24MHz-clock-source.patch \
    file://0005-enable-passthrough-in-uboot.patch \
    file://0006-Add-Aspeed-g5-interrupt-support.patch \
    file://0007-Add-espi-support.patch \
    file://0008-add-sgio-support-for-port80-snoop-post-LEDs.patch \
    file://0009-Add-basic-GPIO-support.patch \
    file://0010-Update-Force-Firmware-Update-Jumper-to-use-new-gpio.patch \
    file://0011-Add-basic-timer-support-for-Aspeed-g5-in-U-Boot.patch \
    file://0012-Add-status-and-ID-LED-support.patch \
    file://0013-aspeed-Add-Pwm-Driver.patch \
    file://0014-Keep-interrupts-enabled-until-last-second.patch \
    file://0015-Rewrite-memmove-to-optimize-on-word-transfers.patch \
    file://0019-u-boot-full-platform-reset-espi-oob-ready.patch \
    file://0020-Enable-PCIe-L1-support.patch \
    file://0020-Add-system-reset-status-support.patch \
    file://0021-Config-host-uart-clock-source-using-environment-vari.patch \
    file://0022-KCS-driver-support-in-uBoot.patch \
    file://0023-Add-TPM-enable-pulse-triggering.patch \
    file://0024-IPMI-command-handler-implementation-in-uboot.patch \
    file://0025-Manufacturing-mode-physical-presence-detection.patch \
    file://0026-Aspeed-I2C-support-in-U-Boot.patch \
    file://0027-CPLD-u-boot-commands-support-for-PFR.patch \
    file://0028-Enabling-uart1-uart2-in-u-boot-for-BIOS-messages.patch \
    file://0029-FFUJ-FW-IPMI-commands-and-flash-support-in-u-boot.patch \
    file://0030-Support-Get-Set-Security-mode-command.patch \
    file://0031-Make-it-so-TFTP-port-can-be-modified.patch \
    file://0033-Reboot-into-UBOOT-on-Watchdog-Failures.patch \
    file://0034-Disable-uart-debug-interface.patch \
    file://0036-Re-Enable-KCS.patch \
    file://0037-aspeed-ast-scu.c-fix-MAC1LINK-and-MAC2LINK-pin-pads-.patch \
    file://0038-Increase-default-fan-speed-for-cooper-city.patch \
    file://0040-Initialize-the-BMC-host-mailbox-at-reset-time.patch \
    file://0044-net-phy-realtek-Change-LED-configuration.patch \
    file://0045-Apply-WDT1-2-reset-mask-to-reset-needed-controller.patch \
    file://0046-Enable-FMC-DMA-for-memmove.patch \
    file://0047-ast2500-parse-reset-reason.patch \
    file://0048-Add-WDT-to-u-boot-to-cover-booting-failures.patch \
    file://0049-Fix-issue-on-host-console-is-broken-due-to-BMC-reset.patch \
    file://0050-Set-UART-routing-in-lowlevel_init.patch \
    "
# CVE-2020-10648 vulnerability fix
SRC_URI_append_intel-ast2500 = " \
    file://0001-image-Correct-comment-for-fit_conf_get_node.patch \
    file://0002-image-Be-a-little-more-verbose-when-checking-signatu.patch \
    file://0003-image-Return-an-error-message-from-fit_config_verify.patch \
    file://0007-image-Check-hash-nodes-when-checking-configurations.patch \
    file://0008-image-Load-the-correct-configuration-in-fit_check_si.patch \
    file://0009-fit_check_sign-Allow-selecting-the-configuration-to-.patch \
    file://0012-image-Use-constants-for-required-and-key-name-hint.patch \
    "
PFR_SRC_URI = " \
    file://0022-u-boot-env-change-for-PFR-image.patch \
    file://0032-PFR-FW-update-and-checkpoint-support-in-u-boot.patch \
    file://0035-PFR-platform-EXTRST-reset-mask-selection.patch \
    file://0043-PFR-Skip-counting-WDT2-event-when-EXTRST-is-set.patch \
    "
AUTOBOOT_SRC_URI = " \
    file://0041-Disabling-boot-delay.patch \
    "
SRC_URI_append_intel-ast2500 += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', PFR_SRC_URI, '', d)}"
SRC_URI_append_intel-ast2500 += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '', AUTOBOOT_SRC_URI, d)}"
do_install_append () {
    install -m 0644 ${WORKDIR}/fw_env.config ${S}/tools/env/fw_env.config
}

require recipes-core/os-release/version-vars.inc

python do_version () {
    with open(d.expand('${S}/board/aspeed/ast-g5/intel-version.h'), 'w') as f:
        f.write(d.expand('#define VER_MAJOR ${IPMI_MAJOR}\n'))
        f.write(d.expand('#define VER_MINOR ${IPMI_MINOR}\n'))
        f.write(d.expand('#define VER_AUX13 ${IPMI_AUX13}\n'))
        f.write(d.expand('#define VER_AUX14 ${IPMI_AUX14}\n'))
        f.write(d.expand('#define VER_AUX15 ${IPMI_AUX15}\n'))
        f.write(d.expand('#define VER_AUX16 ${IPMI_AUX16}\n'))
}

do_version[vardepsexclude] = "IPMI_MAJOR IPMI_MINOR IPMI_AUX13 IPMI_AUX14 IPMI_AUX15 IPMI_AUX16 PRODUCT_GENERATION VERSION VERSION_ID BUILD_ID"
addtask do_version after do_configure before do_compile
