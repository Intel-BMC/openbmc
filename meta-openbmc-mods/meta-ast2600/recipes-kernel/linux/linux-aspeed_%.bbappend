COMPATIBLE_MACHINE = "intel-ast2600"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://intel-ast2600.cfg \
    file://0001-Add-a-workaround-to-cover-UART-interrupt-bug-in-AST2.patch \
    "
