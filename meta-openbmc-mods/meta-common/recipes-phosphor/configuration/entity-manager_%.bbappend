# this is here just to bump faster than upstream
# SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "2a9670820094a9a1847770597b713bf6fb3c08ba"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0001-Improve-initialization-of-I2C-sensors.patch"

