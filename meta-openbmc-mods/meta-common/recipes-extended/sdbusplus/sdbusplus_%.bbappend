FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI = "git://github.com/openbmc/sdbusplus.git;nobranch=1"
SRCREV = "95874d930f0bcc8390cd47ab3bb1e5e46db45278"

SRC_URI += " \
             file://0001-Revert-server-Check-return-code-for-sd_bus_add_objec.patch \
           "

