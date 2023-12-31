FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0035-Fix-build-error.patch \
    file://0036-sunrpc-use-snprintf-to-guard-against-buffer-overflow.patch \
    file://0001-CVE-2022-23218.patch \
    file://0002-CVE-2022-23218.patch \
    file://0001-CVE-2022-23219.patch \
    file://0002-CVE-2022-23219.patch \
    file://CVE-2021-43396.patch \
    file://CVE-2021-3998.patch \
    file://CVE-2023-0687.patch \
    "
