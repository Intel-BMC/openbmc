FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://CVE-2018-25032.patch \
    file://CVE-2022-37434_1.patch \
    file://CVE-2022-37434_2.patch \
    "
