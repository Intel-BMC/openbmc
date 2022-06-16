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
        "

SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'file://1000-128MB-flashmap-for-PFR.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
