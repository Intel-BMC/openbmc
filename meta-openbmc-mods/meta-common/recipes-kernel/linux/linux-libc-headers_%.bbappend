FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Enable-passthrough-based-gpio-character-device.patch \
        "
