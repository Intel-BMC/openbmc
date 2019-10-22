FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI = "git://github.com/openbmc/qemu.git;nobranch=1 \
           file://0001-hw-arm-aspeed-Add-an-intel-ast2500-machine-type.patch \
           file://0002-Turn-Off-FFWUPD-Jumper.patch"

QEMU_TARGETS = "arm"

S = "${WORKDIR}/git"
SRCREV = "5dca85cb0b85ac309d131f9db1fb57af282d67cc"

PACKAGECONFIG[ssh] = "--enable-libssh2,--disable-libssh2,libssh2,"
