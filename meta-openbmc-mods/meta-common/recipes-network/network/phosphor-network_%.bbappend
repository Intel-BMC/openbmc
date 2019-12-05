FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI += "git://github.com/openbmc/phosphor-networkd"
SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
            file://0001-Enhance-DHCP-beyond-just-OFF-and-IPv4-IPv6-enabled.patch \
            "
SRCREV = "cb42fe26febc9e457a9c4279278bd8c85f60851a"
