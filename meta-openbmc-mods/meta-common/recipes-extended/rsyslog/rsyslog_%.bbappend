FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
        sed -i -e"s/ network-online.target//g" ${D}${systemd_system_unitdir}/rsyslog.service
}