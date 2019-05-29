FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SYSTEMD_SUBSTITUTIONS_remove = "KCS_DEVICE:${KCS_DEVICE}:${DBUS_SERVICE_${PN}}"

# Default kcs device is ipmi-kcs3; this is SMS.
# Add SMM kcs device instance
SMM_DEVICE = "ipmi-kcs4"
SYSTEMD_SERVICE_${PN}_append = " ${PN}@${SMM_DEVICE}.service "

SRC_URI = "git://github.com/openbmc/kcsbridge.git"
SRCREV = "2cdc49585235a6557c9cbb6c8b75c064fc02681a"

