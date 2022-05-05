FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
             file://0001-Revert-server-Check-return-code-for-sd_bus_add_objec.patch \
             file://0002-Skip-decoding-some-dbus-identifiers.patch \
           "

# Temporary pin to resolve build breaks
SRCREV="6adfe948ee55ffde8457047042d0d55aa3d8b4a7"
