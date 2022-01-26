FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Fix-NULL-pointer-crashes-CVE-2021-36217.patch \
    file://0002-handle-hup-CVE-2021-3468.patch \
    "
