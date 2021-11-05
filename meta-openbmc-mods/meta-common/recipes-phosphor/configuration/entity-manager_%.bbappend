# this is here just to bump faster than upstream
# SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "8bb94ed6c9d64042ef367b5ff679336ff4d75093"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0002-Entity-manager-Add-support-to-update-assetTag.patch \
             file://0003-Add-logs-to-fwVersionIsSame.patch \
             file://0004-Adding-MUX-and-Drives-present-in-HSBP-in-json-config.patch \
             file://0005-Allow-MUX-idle-state-to-be-configured-as-DISCONNECT.patch \
             file://0006-Change-HSBP-FRU-address-and-add-MUX-mode-configurati.patch \
           "

