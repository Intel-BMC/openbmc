FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "ee5b2c9469a56205567a8b1b120ecf34fc9f5ef4"

SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
           "

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
