# this is here just to bump faster than upstream
# SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "ee70147add704c40e1999900ec8e67d1213729cc"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0002-Entity-manager-Add-support-to-update-assetTag.patch \
             file://0003-Add-logs-to-fwVersionIsSame.patch \
             file://0004-Adding-MUX-and-Drives-present-in-HSBP-in-json-config.patch \
           "

