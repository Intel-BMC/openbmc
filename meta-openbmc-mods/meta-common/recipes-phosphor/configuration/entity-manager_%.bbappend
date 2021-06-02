# this is here just to bump faster than upstream
# SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "1694ef625a1075599e40faa695a40d61ccd91095"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0001-Improve-initialization-of-I2C-sensors.patch \
             file://0002-Entity-manager-Add-support-to-update-assetTag.patch \
             file://0003-Add-logs-to-fwVersionIsSame.patch \
           "

