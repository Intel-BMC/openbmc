FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/phosphor-post-code-manager.git"
SRCREV = "987f91a6536e0330799cc5f4e54740c4023b5ef0"

SRC_URI += "file://0001-Use-binary-serialization-instead-of-JSON.patch"
SRC_URI += "file://0002-Max-post-code-file-size-per-cycle-setting.patch"


