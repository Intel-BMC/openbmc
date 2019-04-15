FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_compile_prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += " \
        file://intel.cfg \
        file://0005-arm-dts-aspeed-g5-add-espi.patch \
        file://0007-New-flash-map-for-intel.patch \
        file://0008-Add-ASPEED-SGPIO-driver.patch \
        file://0009-SGPIO-DT-and-pinctrl-fixup.patch \
        file://0010-Update-PECI-drivers-to-sync-with-linux-upstreaming-v.patch \
        file://0019-Add-I2C-IPMB-support.patch \
        file://0021-Initial-Port-of-Aspeed-LPC-SIO-driver.patch \
        file://0022-Add-AST2500-eSPI-driver.patch \
        file://0026-Add-support-for-new-PECI-commands.patch \
        file://0028-Add-AST2500-JTAG-driver.patch \
        file://0029-i2c-aspeed-Improve-driver-to-support-multi-master-us.patch \
        file://0030-Add-dump-debug-code-into-I2C-drivers.patch \
        file://0031-Add-high-speed-baud-rate-support-for-UART.patch \
        file://0032-misc-aspeed-Add-Aspeed-UART-routing-control-driver.patch \
        file://0034-arm-dts-aspeed-Swap-the-mac-nodes-numbering.patch \
        file://0035-Implement-a-memory-driver-share-memory.patch \
        file://0039-Add-Aspeed-PWM-driver-which-uses-FTTMR010-timer-IP.patch \
        file://0040-i2c-Add-mux-hold-unhold-msg-types.patch \
        file://0041-Enable-passthrough-based-gpio-character-device.patch \
        file://0042-Add-bus-timeout-ms-and-retries-device-tree-propertie.patch \
        file://0043-char-ipmi-Add-clock-control-logic-into-Aspeed-LPC-BT.patch \
        file://0044-misc-Add-clock-control-logic-into-Aspeed-LPC-SNOOP-d.patch \
        file://0045-char-ipmi-Add-clock-control-logic-into-Aspeed-LPC-KC.patch \
        file://0046-misc-Add-clock-control-logic-into-Aspeed-LPC-MBOX-dr.patch \
        file://0047-misc-Block-error-printing-on-probe-defer-case-in-Asp.patch \
        file://0048-ARM-dts-aspeed-Set-default-status-of-LPC-BT-as-disab.patch \
        file://0049-Suppress-excessive-HID-gadget-error-logs.patch \
        file://0050-media-platform-Fix-a-kernel-warning-on-clk-control.patch \
        "
