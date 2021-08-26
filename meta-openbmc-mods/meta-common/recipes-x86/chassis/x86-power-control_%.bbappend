# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/x86-power-control.git;protocol=ssh"
SRCREV = "ec972d8b56fe84f8aa6d18f63e64e3fb0e7a9eaf"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Extend-VR-Watchdog-timeout.patch \
        "
