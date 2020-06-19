FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://rotate-event-logs.service \
            file://rotate-event-logs.sh \
"

do_install_append() {
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/rotate-event-logs.sh ${D}/${bindir}/rotate-event-logs.sh
        rm ${D}${systemd_system_unitdir}/rotate-event-logs.timer
}

SYSTEMD_SERVICE_${PN}_remove = "rotate-event-logs.timer"
