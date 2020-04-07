FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_compile_prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += " \
        file://intel.cfg \
        file://0001-arm-dts-add-DTS-for-Intel-ast2500-platforms.patch \
        file://0001-arm-dts-add-DTS-for-Intel-ast2600-platforms.patch \
        file://0001-arm-dts-base-aspeed-g6-dtsi-fixups.patch \
        file://0002-Enable-pass-through-on-GPIOE1-and-GPIOE3-free.patch \
        file://0003-Enable-GPIOE0-and-GPIOE2-pass-through-by-default.patch \
        file://0006-Allow-monitoring-of-power-control-input-GPIOs.patch \
        file://0007-aspeed-pwm-tacho-change-default-fan-speed.patch \
        file://0014-arm-dts-aspeed-g5-add-espi.patch \
        file://0015-New-flash-map-for-intel.patch \
        file://0016-Add-ASPEED-SGPIO-driver.patch \
        file://0017-SGPIO-DT-and-pinctrl-fixup.patch \
        file://0019-Add-I2C-IPMB-support.patch \
        file://0020-misc-aspeed-add-lpc-mbox-driver.patch \
        file://0021-Initial-Port-of-Aspeed-LPC-SIO-driver.patch \
        file://0022-Add-AST2500-eSPI-driver.patch \
        file://0028-Add-AST2500-JTAG-driver.patch \
        file://0030-Add-dump-debug-code-into-I2C-drivers.patch \
        file://0031-Add-high-speed-baud-rate-support-for-UART.patch \
        file://0032-misc-aspeed-Add-Aspeed-UART-routing-control-driver.patch \
        file://0034-arm-dts-aspeed-Swap-the-mac-nodes-numbering.patch \
        file://0035-Implement-a-memory-driver-share-memory.patch \
        file://0039-Add-Aspeed-PWM-driver-which-uses-FTTMR010-timer-IP.patch \
        file://0040-i2c-Add-mux-hold-unhold-msg-types.patch \
        file://0042-Add-bus-timeout-ms-and-retries-device-tree-propertie.patch \
        file://0043-char-ipmi-Add-clock-control-logic-into-Aspeed-LPC-BT.patch \
        file://0044-misc-Add-clock-control-logic-into-Aspeed-LPC-SNOOP-d.patch \
        file://0045-char-ipmi-Add-clock-control-logic-into-Aspeed-LPC-KC.patch \
        file://0047-misc-Block-error-printing-on-probe-defer-case-in-Asp.patch \
        file://0049-Suppress-excessive-HID-gadget-error-logs.patch \
        file://0051-Add-AST2500-JTAG-device.patch \
        file://0052-drivers-jtag-Add-JTAG-core-driver.patch \
        file://0053-Add-Aspeed-SoC-24xx-and-25xx-families-JTAG.patch \
        file://0054-Documentation-jtag-Add-bindings-for-Aspeed-SoC.patch \
        file://0055-Documentation-jtag-Add-ABI-documentation.patch \
        file://0056-Documentation-jtag-Add-JTAG-core-driver-ioctl-number.patch \
        file://0057-drivers-jtag-Add-JTAG-core-driver-Maintainers.patch \
        file://0061-i2c-aspeed-add-buffer-mode-transfer-support.patch \
        file://0062-i2c-aspeed-add-DMA-mode-transfer-support.patch \
        file://0063-i2c-aspeed-add-general-call-support.patch \
        file://0064-set-idle-disconnect-to-true-in-all-cases.patch \
        file://0068-i2c-aspeed-add-H-W-timeout-support.patch \
        file://0069-i2c-aspeed-add-SLAVE_ADDR_RECEIVED_PENDING-interrupt.patch \
        file://0070-gpio-aspeed-temporary-fix-for-gpiochip-range-setting.patch \
        file://0072-pmbus-add-fault-and-beep-attributes.patch \
        file://0073-Add-IO-statistics-to-USB-Mass-storage-gadget.patch \
        file://0075-Refine-initialization-flow-in-I2C-driver.patch \
        file://0076-arm-ast2600-add-pwm_tacho-driver-from-aspeed.patch \
        file://0077-soc-aspeed-Add-read-only-property-support.patch \
        file://0078-Fix-NCSI-driver-issue-caused-by-host-shutdown.patch \
        file://0080-i2c-aspeed-filter-garbage-interrupts-out.patch \
        file://0084-ARM-dts-aspeed-g6-add-GFX-node.patch \
        file://0085-drm-add-AST2600-GFX-support.patch \
        file://0086-ADC-linux-driver-for-AST2600.patch \
        file://0086-ARM-dts-aspeed-g6-add-video-node.patch \
        file://0087-media-aspeed-add-aspeed-ast2600-video-engine-compati.patch \
        file://0088-clk-ast2600-enable-ESPICLK-always.patch \
        file://0089-ast2600-enable-high-speed-uart-in-kernel.patch \
        file://0090-peci-cpupower-driver-1.patch \
        file://0092-SPI-Quad-IO-driver-support-AST2600.patch \
        file://0093-ipmi-ipmb_dev_int-add-quick-fix-for-raw-I2C-type-reg.patch \
        file://0094-Return-link-speed-and-duplex-settings-for-the-NCSI-c.patch \
	file://0095-pwm-and-tach-driver-changes-for-ast2600.patch \
        file://0096-Fix-truncated-WrEndPointConfig-MMIO-command.patch \
        file://0100-Mailbox-Enabling-interrupt-based-mailbox.patch \
        file://0101-Add-poll-fops-in-eSPI-driver.patch \
        "

SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'file://0005-128MB-flashmap-for-PFR.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
