SRC_URI = "git://github.com/openbmc/ipmbbridge.git"
SRCREV = "8fe0abe6d9f69f735e93d7055687fce4b56e80bf"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Add-dbus-method-SlotIpmbRequest.patch \
           file://ipmb-channels.json \
           "

do_install_append() {
    install -D ${WORKDIR}/ipmb-channels.json \
               ${D}/usr/share/ipmbbridge
}