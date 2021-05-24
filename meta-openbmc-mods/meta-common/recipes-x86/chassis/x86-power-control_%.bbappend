# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/x86-power-control.git;protocol=ssh"
SRCREV = "afd04f0283bfc4854c0100c56ccf8bc1c10c799a"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Extend-VR-Watchdog-timeout.patch \
        "
