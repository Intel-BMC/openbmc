FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
           file://CVE-2022-42010.patch \
           file://CVE-2022-42011.patch \
           file://CVE-2022-42012.patch \
		"
