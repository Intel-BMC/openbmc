FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

#todo: Appu, fix nobranch
SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRC_URI += " file://0004-Improved-IPv6-netmask-parsing.patch \
           "

SRCREV = "1b5ec9c5367947d19bdf6efd08251eeb55dd90f4"

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
