FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

DEPENDS += " gtest"

SRC_URI += "file://0001-Avoid-negated-postcode-write-to-D-Bus.patch"
