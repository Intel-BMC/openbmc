FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

#todo: Appu, fix nobranch
SRC_URI = "git://github.com/openbmc/phosphor-networkd;nobranch=1"
SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
            file://0009-Enhance-DHCP-beyond-just-OFF-and-IPv4-IPv6-enabled.patch \
            file://0011-Added-enable-disable-control-of-the-Network-Interfac.patch \
            "
SRCREV = "ad4bf5ce1292c74ac2ecea413ff27c14cf5748fe"

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
