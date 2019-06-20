FILESEXTRAPATHS_append_intel-ast2500:= "${THISDIR}/files:"

# the meta-phosphor layer adds this patch, which conflicts
# with the intel layout for environment
SRC_URI_remove_intel-ast2500 = " file://0001-configs-ast-Add-redundnant-env.patch"

SRC_URI_append_intel-ast2500 = " \
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
    "
SRC_URI_append_intel-ast2500 += "${@bb.utils.contains('IMAGE_TYPE', 'pfr', 'file://0022-u-boot-env-change-for-PFR-image.patch', '', d)}"

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
