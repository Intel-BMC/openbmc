FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "d49c5c650bd6b13f267d59be452ac2b4493e8201"

SRC_URI += " file://0003-Adding-channel-specific-privilege-to-network.patch \
           "

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
EXTRA_OECONF_append = " --enable-ipv6-accept-ra=yes"
