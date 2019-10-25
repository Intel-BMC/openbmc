FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/obmc-ikvm"
SRCREV = "7cf1f1d43ef9b4c312bfb2c7c61514ca93a53ee6"

SRC_URI += " \
    file://0003-Fix-keyboard-and-mouse-input-events-dropping-issue.patch \
    "
