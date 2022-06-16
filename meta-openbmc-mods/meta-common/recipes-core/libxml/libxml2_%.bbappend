FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://CVE-2022-23308-Use-after-free-of-ID-and-IDREF.patch \
           "
