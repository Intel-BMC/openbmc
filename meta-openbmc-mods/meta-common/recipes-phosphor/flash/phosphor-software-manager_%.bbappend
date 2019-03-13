FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
EXTRA_OECONF += "--enable-fwupd_script"

SYSTEMD_SERVICE_${PN}-updater += "fwupd@.service"

SRC_URI_remove = "git://github.com/openbmc/phosphor-bmc-code-mgmt"
SRC_URI += "git://git@github.com/Intel-BMC/phosphor-bmc-code-mgmt.git;protocol=ssh"
SRCREV = "72d1766ac5e492a4c314a40aab3bd687e00c8330"

#Currently enforcing image signature validation only for PFR images
PACKAGECONFIG_append = "${@bb.utils.contains('IMAGE_TYPE', 'pfr', ' verify_signature', '', d)}"
