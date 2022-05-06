# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/pfr-manager"
SRCREV = "57f42c3d37d9546ede4f2c015bf9f392130c93b5"
DEPENDS += " libgpiod \
           "

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-mainapp-Modify-Redfish-MessageID-from-Panic-to-Resil.patch \
           "
