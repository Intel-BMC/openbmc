FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
           file://CVE-2021-43618-Avoid-bit-size-overflows.patch \
           "
