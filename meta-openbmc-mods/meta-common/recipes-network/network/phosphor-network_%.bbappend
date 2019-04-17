FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json"

SRC_URI += "file://0001-Patch-to-keep-consistent-MAC-and-IP-address-inbetwee.patch \
            file://0002-IPv6-Network-changes-to-configuration-file.patch \
            file://0003-Adding-channel-specific-privilege-to-network.patch \
            "

