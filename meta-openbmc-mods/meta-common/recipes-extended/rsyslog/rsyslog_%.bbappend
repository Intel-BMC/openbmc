FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://CVE-2022-24903.patch \
    "

do_install:append() {
        sed -i -e"s/ network-online.target//g" ${D}${systemd_system_unitdir}/rsyslog.service
}
