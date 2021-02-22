# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/x86-power-control.git;protocol=ssh"
SRCREV = "273d789718ce2a7aaf49424f9cefcd89226da2a7"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Extend-VR-Watchdog-timeout.patch \
        file://0002-save-current-power-state-in-tmp-file.patch \
        "
