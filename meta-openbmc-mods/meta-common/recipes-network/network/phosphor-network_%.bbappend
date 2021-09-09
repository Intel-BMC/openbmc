FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

#todo: Appu, fix nobranch
SRC_URI = "git://github.com/openbmc/phosphor-networkd;nobranch=1"
SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
            file://0009-Enhance-DHCP-beyond-just-OFF-and-IPv4-IPv6-enabled.patch \
            file://0010-Correct-several-latent-issues-discovered-by-a-Klocwo.patch \
            "
SRCREV = "d0679f9bb46670c593061c4aaebec2a577cdd5c3"

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
