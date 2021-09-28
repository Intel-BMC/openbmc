FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "b108fd740fdde4a9f0fe63e63ccdee695f5b92e7"

SRC_URI += " file://0003-Adding-channel-specific-privilege-to-network.patch \
             file://0004-Fix-for-updating-MAC-address-from-RedFish.patch \
             file://0005-Added-debug-logs-to-isolate-the-coredump-issue-of-RT.patch \
           "

EXTRA_OECONF:append = " --enable-nic-ethtool=yes"
EXTRA_OECONF:append = " --enable-ipv6-accept-ra=yes"
