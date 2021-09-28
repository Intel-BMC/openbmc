FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI += " \
    file://0001-Enable-per-frame-CRC-calculation-option-to-save-netw.patch \
    "
