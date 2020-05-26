COMPATIBLE_MACHINE = "intel-ast2600"
FILESEXTRAPATHS_prepend := "${THISDIR}/linux-aspeed:"
#SRCREV="f9e04c3157234671b9d5e27bf9b7025b8b21e0d4"
#LINUX_VERSION="5.2.11"

# TODO: the base kernel dtsi fixups patch should be pushed upstream
SRC_URI += " \
    file://intel-ast2600.cfg \
    file://0001-Add-a-workaround-to-cover-UART-interrupt-bug-in-AST2.patch \
    "
