FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/obmc-ikvm"
SRCREV = "861337e8ec92767c4c88237ec5db494a2a67fa8d"

SRC_URI += " \
    file://0003-Fix-keyboard-and-mouse-input-events-dropping-issue.patch \
    file://0004-Connect-HID-gadget-device-dynamically.patch \
    file://0005-Refine-HID-report-writing-logic.patch \
    "
