FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LINUX_VERSION = "5.15"

KBRANCH = "dev-5.15-intel"
KSRC = "git://git@github.com/Intel-BMC/linux.git;protocol=ssh;branch=${KBRANCH}"
# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://git@github.com/Intel-BMC/linux.git;protocol=ssh;branch=dev-5.15-intel"
SRCREV="aaccb149bfa6ff74dc8e9ff043191730060002db"

do_compile:prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += " \
        file://intel.cfg \
        file://0001-peci-aspeed-Improve-workaround-for-controller-hang.patch \
        file://0002-gpio-gpio-aspeed-sgpio-Fix-wrong-hwirq-base-in-irq-h.patch \
        file://0003-Add-mux-deselect-support-on-timeout.patch \
        file://CVE-2022-0185.patch \
        file://CVE-2021-22600.patch \
        file://CVE-2022-24122.patch \
        file://CVE-2022-0492.patch \
        file://CVE-2022-25258.patch \
        file://CVE-2022-0742.patch\
        file://CVE-2021-4197-001.patch \
        file://CVE-2021-4197-002.patch\
        file://CVE-2021-4197-003.patch\
        file://CVE-2021-44733.patch\
        file://CVE-2022-29582.patch\
        file://CVE-2022-30594.patch\
        file://CVE-2022-20008.patch\
        file://CVE-2022-1998.patch\
        file://CVE-2022-32296.patch\
        file://CVE-2021-39685.patch\
        file://CVE-2021-39685-1.patch\
        file://CVE-2021-39685-2.patch\
        file://CVE-2021-39698.patch\
        file://CVE-2021-39698-1.patch\
        file://CVE-2021-4083.patch\
        file://CVE-2022-1729.patch\
        file://CVE-2022-1184_1.patch\
        file://CVE-2022-1184_2.patch\
        file://CVE-2022-2938.patch\
        file://CVE-2022-2959.patch\
        file://CVE-2022-1012.patch\
        file://CVE-2022-2503.patch\
        file://CVE-2022-20368.patch\
        file://CVE-2022-0168.patch\
        file://CVE-2022-40476.patch\
        file://CVE-2022-2663-1.patch\
        file://CVE-2022-2663-2.patch\
        file://CVE-2022-20158-1.patch\
        file://0004-soc-aspeed-lpc-mbox-Don-t-allow-partial-reads.patch \
        file://CVE-2022-3543.patch \
        file://CVE-2022-42703.patch \
        file://CVE-2022-4378-1.patch \
        file://CVE-2022-4378-2.patch \
        file://CVE-2022-2978.patch \
        file://CVE-2022-3623.patch \
        file://CVE-2023-0394.patch \
        file://CVE-2023-1252.patch\
        file://CVE-2023-1073.patch\
        file://CVE-2023-1077.patch\
        file://CVE-2023-1582.patch \
        file://CVE-2020-36516.patch \
        file://0005-ext4-add-EXT4_INODE_HAS_XATTR_SPACE-macro-in-xattr-h.patch \
        file://CVE-2023-2513.patch \
        file://CVE-2023-2269.patch \
        "
SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'file://1000-128MB-flashmap-for-PFR.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
