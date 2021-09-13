# this is here just to bump faster than upstream
SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "e18edb5badc2e16181cfc464a6ccd0ef51dc4548"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Add-retries-to-mapper-calls.patch \
            file://0002-Improve-initialization-of-I2C-sensors.patch \
            file://0003-Klocwork-fix-fruDevice.patch"
