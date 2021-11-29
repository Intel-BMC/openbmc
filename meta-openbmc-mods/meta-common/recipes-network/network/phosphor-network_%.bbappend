FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "205cc104cced7bca2521825b987dc7041d961a65"

SRC_URI += " file://0003-Adding-channel-specific-privilege-to-network.patch \
             file://0004-Fix-for-updating-MAC-address-from-RedFish.patch \
           "

EXTRA_OECONF:append = " --enable-nic-ethtool=yes"
EXTRA_OECONF:append = " --enable-ipv6-accept-ra=yes"
