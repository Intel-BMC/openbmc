FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

SRC_URI = "git://github.com/openbmc/phosphor-networkd"
SRCREV = "2c0fc568057c5575a75ad638ea91bc8c65b57160"

SRC_URI += " file://0003-Adding-channel-specific-privilege-to-network.patch \
             file://0004-Fix-for-updating-MAC-address-from-RedFish.patch \
             file://0005-Added-debug-logs-to-isolate-the-coredump-issue-of-RT.patch \
           "

EXTRA_OECONF:append = " --enable-nic-ethtool=yes"
EXTRA_OECONF:append = " --enable-ipv6-accept-ra=yes"
