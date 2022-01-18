FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LINUX_VERSION = "5.15"

KBRANCH = "dev-5.15-intel"
KSRC = "git://github.com/Intel-BMC/linux;protocol=ssh;branch=${KBRANCH}"
# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://github.com/Intel-BMC/linux;protocol=ssh;branch=dev-5.15-intel"
SRCREV="c7981259e359523e74044f926b69a804c61c86b1"

do_compile:prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += " \
        file://intel.cfg \
        "

SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'file://1000-128MB-flashmap-for-PFR.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
