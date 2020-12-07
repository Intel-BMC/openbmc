SRC_URI = "git://github.com/openbmc/ipmbbridge.git"
SRCREV = "3e07b9ea353b794f9ef666172265ecc056e5cd4d"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Add-dbus-method-SlotIpmbRequest.patch \
           file://ipmb-channels.json \
           "

do_install_append() {
    install -D ${WORKDIR}/ipmb-channels.json \
               ${D}/usr/share/ipmbbridge
}