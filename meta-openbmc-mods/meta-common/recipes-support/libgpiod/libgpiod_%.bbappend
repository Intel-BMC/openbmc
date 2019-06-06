FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG += " cxx"

SRC_URI += " \
        file://0001-Add-pass-through-setting-in-gpioset.patch \
        "
