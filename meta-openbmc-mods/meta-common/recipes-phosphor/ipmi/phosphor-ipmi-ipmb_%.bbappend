SRC_URI = "git://github.com/openbmc/ipmbbridge.git"
SRCREV = "bd78df6be9f677136ca190d50101c328267ddcd2"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Add-dbus-method-SlotIpmbRequest.patch \
           file://0002-Add-log-count-limitation-to-requestAdd.patch \
           file://ipmb-channels.json \
           "

do_install:append() {
    install -D ${WORKDIR}/ipmb-channels.json \
               ${D}/usr/share/ipmbbridge
}
