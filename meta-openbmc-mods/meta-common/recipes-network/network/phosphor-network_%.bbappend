FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "cc5a670f1650e76b66750365bd4beecf821969fa"

SRC_URI += " file://0003-Adding-channel-specific-privilege-to-network.patch \
             file://0004-Revert-ethernet_interface-Defer-setting-NIC-enabled.patch \
           "

EXTRA_OECONF:append = " --enable-nic-ethtool=yes"
EXTRA_OECONF:append = " --enable-ipv6-accept-ra=yes"
