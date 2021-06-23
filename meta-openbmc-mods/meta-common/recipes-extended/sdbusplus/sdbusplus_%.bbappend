FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
             file://0001-Revert-server-Check-return-code-for-sd_bus_add_objec.patch \
           "
