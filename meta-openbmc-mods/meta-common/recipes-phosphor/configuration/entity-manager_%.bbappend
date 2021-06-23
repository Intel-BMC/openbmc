# this is here just to bump faster than upstream
# SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "cda147301b0fa7eac99eee3a7565604dbd6f74dd"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0002-Entity-manager-Add-support-to-update-assetTag.patch \
             file://0003-Add-logs-to-fwVersionIsSame.patch \
           "

