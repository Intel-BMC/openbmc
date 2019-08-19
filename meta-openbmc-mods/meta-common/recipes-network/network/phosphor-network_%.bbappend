FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json"

SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
            "
SRCREV = "f273d2b5629d2a7d96802dc7a7ddb92e303ac8de"

