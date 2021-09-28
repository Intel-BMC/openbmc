FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0035-Fix-build-error.patch \
    file://0036-sunrpc-use-snprintf-to-guard-against-buffer-overflow.patch \
    "
