FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

DEPENDS += " gtest"

#SRC_URI = "git://github.com/openbmc/phosphor-host-postd.git"
SRCREV = "6a5e0a1cba979c3c793e794c41481221da9a4e33"

SRC_URI += "file://0001-Avoid-negated-postcode-write-to-D-Bus.patch"
SRC_URI += "file://0002-Add-rate-limiting.patch"
