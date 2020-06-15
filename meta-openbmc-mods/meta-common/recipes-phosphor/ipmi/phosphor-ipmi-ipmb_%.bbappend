SRC_URI = "git://github.com/openbmc/ipmbbridge.git"
SRCREV = "a86059348fe133725f4616f3e46ff0d555db4039"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Add-dbus-method-SlotIpmbRequest.patch"
