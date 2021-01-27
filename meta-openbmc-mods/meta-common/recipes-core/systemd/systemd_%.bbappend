# add some configuration overrides for systemd defaults

LICENSE = "GPL-2.0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Modfiy-system.conf-DefaultTimeoutStopSec.patch \
            file://systemd-time-wait-sync.service \
           "

USERADD_PACKAGES_remove = "${PN}-journal-gateway ${PN}-journal-upload ${PN}-journal-remote"

do_install_append(){
    rm -rf ${D}/lib/udev/rules.d/80-drivers.rules
    cp -f ${WORKDIR}/systemd-time-wait-sync.service ${D}/lib/systemd/system/
}

PACKAGECONFIG_remove = " kmod"
PACKAGECONFIG_append = " logind"
