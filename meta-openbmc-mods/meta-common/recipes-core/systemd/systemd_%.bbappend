# add some configuration overrides for systemd default /usr/lib/tmpfiles.d/

LICENSE = "GPL-2.0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://000-ro-rootfs-tmpfile-defaults.patch \
            file://0001-Modfiy-system.conf-DefaultTimeoutStopSec.patch \
           "

USERADD_PACKAGES_remove = "${PN}-journal-gateway ${PN}-journal-upload ${PN}-journal-remote"
