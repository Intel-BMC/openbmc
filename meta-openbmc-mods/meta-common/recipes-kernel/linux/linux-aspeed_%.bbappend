FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

LINUX_VERSION="5.4.48"
SRCREV="2b4829edfc1c225c717652153097470529d171db"

do_compile_prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += " \
        file://intel.cfg \
        file://0001-arm-dts-add-DTS-for-Intel-ast2500-platforms.patch \
        file://0001-arm-dts-intel-s2600wf-dts-fixups.patch \
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
        file://0102-Fix-for-dirty-node-in-jffs2-summary-entry.patch \
        file://0103-Refine-clock-settings.patch \
        file://0104-Add-chip-unique-id-reading-interface.patch \
        file://0105-i2c-aspeed-fix-arbitration-loss-handling-logic.patch \
        file://0106-enable-AST2600-I3C.patch \
        file://0107-arm-dts-aspeed-g6-Add-ast2600-mctp-node.patch \
        file://0108-soc-aspeed-mctp-Add-initial-driver-for-ast2600-mctp.patch \
        file://0110-USB-gadget-fix-illegal-array-access-in-binding-with-.patch \
        file://0111-Unconditionally-calculate-the-PECI-AW-FCS.patch \
        file://0112-AST2600-enable-UART-routing.patch \
        file://0113-hwmon-peci-PCS-utils.patch \
        file://0114-hwmon-peci-cpupower-extension.patch \
        file://0115-hwmon-peci-dimmpower-implementation.patch \
        file://0116-watchdog-aspeed-fix-AST2600-support.patch \
        file://0117-Copy-raw-PECI-response-to-user-space-on-timeout.patch \
        file://0118-Recalculate-AW-FCS-on-WrEndPointConfig-command.patch \
        file://0119-Handle-pending-eSPI-HOST-OOB-RESET-VW-events.patch \
        file://0123-peci-fix-error-handling-in-peci_dev_ioctl.patch \
        file://1001-Igore-0x3FF-in-aspeed_adc-driver.patch \
        file://0120-media-aspeed-adjust-irq-enabling-timing-and-resource.patch \
        file://1002-Filter-erroneous-adc-readings.patch \
        file://0121-Add-a-WA-to-defer-flash-writes-on-PS_ALERT_N-asserti.patch \
        file://0125-i2c-aspeed-clear-slave-addresses-in-probe.patch \
        file://0126-Adjust-soc-modules-probing-order.patch \
        file://1003-Die_CPU-filter-first-zero-from-GetTemp.patch \
        file://1004-DTS_CPU-filter-first-zero-from-RdPkgConfig-10.patch \
        "

# CVE-2020-16166 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-16166:"
SRC_URI += " \
    file://0001-random32-update-the-net-random-state-on-interrupt-an.patch \
    "

# CVE-2019-19770 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2019-19770:"
SRC_URI += " \
    file://0001-blktrace-fix-debugfs-use-after-free.patch \
    "

# CVE-2020-14356 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-14356:"
SRC_URI += " \
    file://0001-cgroup-fix-cgroup_sk_alloc-for-sk_clone_lock.patch \
    file://0002-cgroup-Fix-sock_cgroup_data-on-big-endian.patch \
    "

# CVE-2020-14386 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-14386:"
SRC_URI += " \
    file://0001-net-packet-fix-overflow-in-tpacket_rcv.patch \
    "

# CVE-2020-25705 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-25705:"
SRC_URI += " \
    file://0001-icmp-randomize-the-global-rate-limiter.patch \
    "

# CVE-2020-15436 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-15436:"
SRC_URI += " \
    file://0001-block-Fix-use-after-free-in-blkdev_get.patch \
    "

# CVE-2020-29369 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-29369:"
SRC_URI += " \
    file://0001-mm-mmap.c-close-race-between-munmap-and-expand_upwar.patch \
    "

# CVE-2020-15437 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-15437:"
SRC_URI += " \
    file://0001-serial-8250-fix-null-ptr-deref-in-serial8250_start_t.patch \
    "

# CVE-2020-25704 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-25704:"
SRC_URI += " \
    file://0001-perf-core-Fix-a-memory-leak-in-perf_event_parse_addr.patch \
    "

# CVE-2020-29372 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-29372:"
SRC_URI += " \
    file://0001-mm-check-that-mm-is-still-valid-in-madvise.patch \
    "

# CVE-2020-14351 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-14351:"
SRC_URI += " \
    file://0001-perf-core-Fix-race-in-the-perf_mmap_close-function.patch \
    "

# CVE-2020-29661 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-29661:"
SRC_URI += " \
    file://0001-tty-Fix-pgrp-locking-in-tiocspgrp.patch \
    "

# CVE-2020-29660 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-29660:"
SRC_URI += " \
    file://0001-tty-Fix-session-locking.patch \
    "

# CVE-2020-29569 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-29569:"
SRC_URI += " \
    file://0001-xen-blkback-set-ring-xenblkd-to-null-after-kthread-stop.patch \
    "

# CVE-2020-0465 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-0465:"
SRC_URI += " \
    file://0001-HID-core-Correctly-handle-ReportSize-being-zero.patch \
    "

# CVE-2020-0466 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-0466:"
SRC_URI += " \
    file://0001-epoll-Keep-a-reference-on-files-added-to-the-check-l.patch \
    "

# CVE-2020-27825 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-27825:"
SRC_URI += " \
    file://0001-tracing-Fix-race-in-trace_open-and-buffer-resize-cal.patch \
    "

# CVE-2021-3347 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2021-3347:"
SRC_URI += " \
    file://0001-futex-Fix-incorrect-should_fail_futex-handling.patch \
    file://0002-futex-Handle-transient-ownerless-rtmutex-state-corre.patch \
    file://0003-futex-Don-t-enable-IRQs-unconditionally-in-put_pi_st.patch \
    file://0004-futex-Ensure-the-correct-return-value-from-futex_loc.patch \
    file://0005-futex-Replace-pointless-printk-in-fixup_owner.patch \
    file://0006-futex-Provide-and-use-pi_state_update_owner.patch \
    file://0007-rtmutex-Remove-unused-argument-from-rt_mutex_proxy_u.patch \
    file://0008-futex-Use-pi_state_update_owner-in-put_pi_state.patch \
    file://0009-futex-Simplify-fixup_pi_state_owner.patch \
    file://0010-futex-Handle-faults-correctly-for-PI-futexes.patch \
    "

# CVE-2020-35508 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-35508:"
SRC_URI += " \
    file://0001-fork-fix-copy_process-CLONE_PARENT-race-with-the-exi.patch \
    "

# CVE-2021-29650 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2021-29650:"
SRC_URI += " \
    file://0001-netfilter-x_tables-Use-correct-memory-barriers.patch \
    "

# CVE-2021-30002 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2021-30002:"
SRC_URI += " \
    file://0001-media-v4l-ioctl-Fix-memory-leak-in-video_usercopy.patch \
    "

# CVE-2020-28588 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-28588:"
SRC_URI += " \
    file://0001-lib-syscall-fix-syscall-registers-retrieval-on-32-bi.patch \
    "

# CVE-2020-27815 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2020-27815:"
SRC_URI += " \
    file://0001-jfs-Fix-array-index-bounds-check-in-dbAdjTree.patch \
    "

# CVE-2021-20177 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2021-20177:"
SRC_URI += " \
    file://0001-netfilter-add-and-use-nf_hook_slow_list.patch \
    "

# CVE-2021-31916 vulnerability fix
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2021-31916:"
SRC_URI += " \
    file://0001-dm-ioctl-fix-out-of-bounds-array-access-when-no-devi.patch \
    "

SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'file://0005-128MB-flashmap-for-PFR.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
