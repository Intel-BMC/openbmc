FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "file://init"

RDEPENDS_${PN} += "bash"
