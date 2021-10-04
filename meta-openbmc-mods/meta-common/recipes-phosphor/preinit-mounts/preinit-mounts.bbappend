FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "file://init"

RDEPENDS:${PN} += "bash"
