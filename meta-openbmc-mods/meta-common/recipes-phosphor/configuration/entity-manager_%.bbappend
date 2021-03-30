# this is here just to bump faster than upstream
# SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "296667f0076888f3cdf898a3f2cdf66da260853e"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0001-Improve-initialization-of-I2C-sensors.patch \
             file://0002-Entity-manager-Add-support-to-update-assetTag.patch \
           "

