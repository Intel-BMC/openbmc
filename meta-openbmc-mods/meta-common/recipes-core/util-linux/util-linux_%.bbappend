FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/CVE-2021-37600:"
SRC_URI += " \
    file://0001-sys-utils-ipcutils-be-careful-when-call-calloc-for-u.patch \
    "
