# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/x86-power-control.git;protocol=ssh"
SRCREV = "48c94c59728023cdbff3bd62f203de3434af8b8a"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Extend-VR-Watchdog-timeout.patch \
        "
