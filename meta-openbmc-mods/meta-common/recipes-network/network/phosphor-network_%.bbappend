FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json"

SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
            file://0001-Enable-ethtool-to-retrieve-the-NIC-speed-duplex-auto.patch \
            "
SRCREV = "f273d2b5629d2a7d96802dc7a7ddb92e303ac8de"

