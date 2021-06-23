FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "de433b74ec5bce22043ea44c55e83d9be3dc5372"

SRC_URI += " file://0003-Adding-channel-specific-privilege-to-network.patch \
           "

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
EXTRA_OECONF_append = " --enable-ipv6-accept-ra=yes"
