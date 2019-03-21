FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
EXTRA_OECONF += "--enable-fwupd_script"

SYSTEMD_SERVICE_${PN}-updater += "fwupd@.service"

SRC_URI_remove = "git://github.com/openbmc/phosphor-bmc-code-mgmt"
SRC_URI += "git://git@github.com/Intel-BMC/phosphor-bmc-code-mgmt;protocol=ssh"
SRCREV = "f8f76c29dbe2806a6eacd15847563cdf7f7567f4"

#Currently enforcing image signature validation only for PFR images
PACKAGECONFIG_append = "${@bb.utils.contains('IMAGE_TYPE', 'pfr', ' verify_signature', '', d)}"
