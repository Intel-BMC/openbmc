# add some configuration overrides for systemd defaults

LICENSE = "GPL-2.0"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Modfiy-system.conf-DefaultTimeoutStopSec.patch \
            file://systemd-time-wait-sync.service \
            file://0002-Add-event-log-for-system-time-synchronization.patch \
           "

USERADD_PACKAGES:remove = "${PN}-journal-gateway ${PN}-journal-upload ${PN}-journal-remote"

do_install:append(){
    rm -rf ${D}/lib/udev/rules.d/80-drivers.rules
    cp -f ${WORKDIR}/systemd-time-wait-sync.service ${D}/lib/systemd/system/
}

PACKAGECONFIG:remove = " kmod"
PACKAGECONFIG:append = " logind"
