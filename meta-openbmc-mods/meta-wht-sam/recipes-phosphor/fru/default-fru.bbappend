FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://decodeBoardID.sh;subdir=${BP}"
