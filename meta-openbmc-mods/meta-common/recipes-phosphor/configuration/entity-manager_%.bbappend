# this is here just to bump faster than upstream
# SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "3b802f1c8c030965b76737966b9b022433e6ef5b"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0001-fru-device-Add-MUX-channel-name-to-FRU-objects.patch \
             file://0002-Entity-manager-Add-support-to-update-assetTag.patch \
             file://0003-Add-logs-to-fwVersionIsSame.patch \
             file://0004-Adding-MUX-and-Drives-present-in-HSBP-in-json-config.patch \
             file://0005-Allow-MUX-idle-state-to-be-configured-as-DISCONNECT.patch \
             file://0006-Change-HSBP-FRU-address-and-add-MUX-mode-configurati.patch \
             file://0007-Add-HSBP-FRU-details-in-json-configuration.patch \
             file://0008-dynamic-threshold-configuration-for-SOLUM-PSU.patch \
           "

