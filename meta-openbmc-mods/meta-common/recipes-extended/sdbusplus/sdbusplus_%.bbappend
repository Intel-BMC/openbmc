FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
             file://0001-Revert-server-Check-return-code-for-sd_bus_add_objec.patch \
             file://0002-Skip-decoding-some-dbus-identifiers.patch \
           "

# Temporary pin to resolve build breaks
SRCREV="90fab6bb667460053cfc4587b58c987f74b1bf58"
