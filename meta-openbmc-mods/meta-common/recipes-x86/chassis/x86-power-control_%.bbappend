# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/x86-power-control.git;protocol=ssh"
SRCREV = "01a77864f49088bac80474587a123d1f152f2b26"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Extend-VR-Watchdog-timeout.patch \
        "
