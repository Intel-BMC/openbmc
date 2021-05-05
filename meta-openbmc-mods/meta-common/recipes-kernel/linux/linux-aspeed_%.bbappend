FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-5.10-intel"
KSRC = "git://github.com/Intel-BMC/linux;protocol=ssh;branch=${KBRANCH}"
# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://github.com/Intel-BMC/linux;protocol=ssh;branch=dev-5.10-intel"
SRCREV="807fd9e1636097ca70957a3ff373bd1280737e46"

do_compile_prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += " \
        file://intel.cfg \
        file://0001-peci-Add-debug-printing-to-check-caller-PID.patch \
        file://0002-soc-aspeed-add-AST2600-A0-specific-fix-into-mbox-dri.patch \
        file://0003-Fix-libmctp-build-error.patch \
        file://0004-Add-a-quick-fix-to-resolve-USB-gadget-DMA-issue.patch \
        "

SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'file://0005-128MB-flashmap-for-PFR.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
