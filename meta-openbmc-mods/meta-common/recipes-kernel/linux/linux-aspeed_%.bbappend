FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LINUX_VERSION = "5.10.60"

KBRANCH = "dev-5.10-intel"
KSRC = "git://github.com/Intel-BMC/linux;protocol=ssh;branch=${KBRANCH}"
# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://github.com/Intel-BMC/linux;protocol=ssh;branch=dev-5.10-intel"
SRCREV="c6e2963874ca7454eb901b4ac668f05b36cf03c8"

do_compile:prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += " \
        file://intel.cfg \
        file://0001-peci-Add-debug-printing-to-check-caller-PID.patch \
        file://0002-soc-aspeed-add-AST2600-A0-specific-fix-into-mbox-dri.patch \
        file://0003-Fix-libmctp-build-error.patch \
        file://0004-Add-a-quick-fix-to-resolve-USB-gadget-DMA-issue.patch \
        file://0005-Die_CPU-filter-first-zero-from-GetTemp.patch \
        file://0006-DTS_CPU-filter-first-zero-from-RdPkgConfig-10.patch \
        file://0007-peci-cputemp-filter-the-first-zero-from-RdPkgConfig-.patch \
        file://0008-vegman-kernel-add-RTC-driver-for-PCHC620.patch \
        file://0009-ARM-dts-add-rtc-pch-node-into-aspeed-bmc-intel-ast2x.patch \
        "

SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'file://1000-128MB-flashmap-for-PFR.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
