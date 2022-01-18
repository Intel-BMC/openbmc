COMPATIBLE_MACHINE = "intel-ast2600"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://intel-ast2600.cfg \
    file://0001-serial-8250-Add-Aspeed-UART-driver-with-DMA-supporte.patch \
    file://0002-serial-8250-Fix-RX-DMA-time-out-property.patch \
    file://0003-serial-8250_aspeed-Make-port-type-fixed.patch \
    file://0004-Add-a-workaround-to-cover-UART-interrupt-bug-in-AST2.patch \
    "
