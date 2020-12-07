FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

#todo: Appu, fix nobranch
SRC_URI = "git://github.com/openbmc/phosphor-networkd"

SRCREV = "ffcba341a893318588afe83e8d767d8c20fd9189"

EXTRA_OECONF_append = " --enable-nic-ethtool=yes"
