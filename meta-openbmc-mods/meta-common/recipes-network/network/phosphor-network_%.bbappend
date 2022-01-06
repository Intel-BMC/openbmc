FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "ee2cba8a7d22ef4a251181087e9ef9bfc5c4b165"

SRC_URI += " file://0003-Adding-channel-specific-privilege-to-network.patch \
             file://0004-Fix-for-updating-MAC-address-from-RedFish.patch \
           "

EXTRA_OECONF:append = " --enable-nic-ethtool=yes"
EXTRA_OECONF:append = " --enable-ipv6-accept-ra=yes"
