FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

#todo: Appu, fix nobranch
SRC_URI = "git://github.com/openbmc/phosphor-networkd;nobranch=1"
SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
            file://0005-Enable-conditional-use-of-ETHTOOL-features-in-the-NI.patch \
            file://0009-Enhance-DHCP-beyond-just-OFF-and-IPv4-IPv6-enabled.patch \
            file://0010-Enable-the-network-link-carrier-state-to-be-reported.patch \
            file://0011-Added-enable-disable-control-of-the-Network-Interfac.patch \
            "
SRCREV = "dbd328d7e037b1af13fb0f20f3708e2261b9e0b6"

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
