SRC_URI = "git://github.com/openbmc/ipmbbridge.git"
SRCREV = "8227626764edf13350c5f5a5857298a905fb43f7"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Add-dbus-method-SlotIpmbRequest.patch \
           file://0002-Add-log-count-limitation-to-requestAdd.patch \
           file://0003-Fix-for-clearing-outstanding-requests.patch \
           file://ipmb-channels.json \
           "

do_install:append() {
    install -D ${WORKDIR}/ipmb-channels.json \
               ${D}/usr/share/ipmbbridge
}
