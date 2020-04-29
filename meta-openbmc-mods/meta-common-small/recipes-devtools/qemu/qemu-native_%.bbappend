FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI = "git://github.com/openbmc/qemu.git;nobranch=1 \
           file://0001-hw-arm-aspeed-Add-an-intel-ast2500-machine-type.patch"

QEMU_TARGETS = "arm"

S = "${WORKDIR}/git"
SRCREV = "8ab0db0624b454bd69a04ca0010f165cb7119100"
