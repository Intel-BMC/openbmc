FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://journald.conf \
            file://systemd-timesyncd-save-time.conf \
           "

FILES_${PN} += " ${systemd_system_unitdir}/systemd-timesyncd.service.d/systemd-timesyncd-save-time.conf"

do_install_append() {
        install -m 644 -D ${WORKDIR}/systemd-timesyncd-save-time.conf ${D}${systemd_system_unitdir}/systemd-timesyncd.service.d/systemd-timesyncd-save-time.conf
}
