FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-5.8-intel"
KSRC = "git://github.com/Intel-BMC/linux;protocol=ssh;branch=${KBRANCH}"
# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://github.com/Intel-BMC/linux;protocol=ssh;branch=dev-5.8-intel"
SRCREV="9f71530c30ebbec6fc5267475b5517add7ad40ce"

do_compile_prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += " \
        file://intel.cfg \
        "

SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'file://0005-128MB-flashmap-for-PFR.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
