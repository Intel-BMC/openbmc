FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "1ea359943afbd59168f490778a528c858903b74d"

SRC_URI += " file://0003-Adding-channel-specific-privilege-to-network.patch \
             file://0004-Fix-for-updating-MAC-address-from-RedFish.patch \
           "

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
EXTRA_OECONF_append = " --enable-ipv6-accept-ra=yes"
