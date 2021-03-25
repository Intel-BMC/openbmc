FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "1b5ec9c5367947d19bdf6efd08251eeb55dd90f4"

SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
            file://0004-Improved-IPv6-netmask-parsing.patch \
           "

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
