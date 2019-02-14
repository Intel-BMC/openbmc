FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DBUS_SERVICE_${PN} += "org.openbmc.HostIpmi.SMM.service"

SYSTEMD_SUBSTITUTIONS_remove = "KCS_DEVICE:${KCS_DEVICE}:${DBUS_SERVICE_${PN}}"

SRC_URI = "git://github.com/openbmc/kcsbridge.git"
SRCREV = "17a2ab7f39a78ff0603aa68cf35108ea94eb442f"

