SYSTEMD_LINK_${PN}_remove += "../op-start-host@.service:obmc-host-startmin@0.target.requires/op-start-host@0.service"
SYSTEMD_LINK_${PN}_remove += "../op-init-pnor@.service:obmc-host-startmin@0.target.requires/op-init-pnor@0.service"

FILES_${PN}_remove = "${systemd_unitdir}/system/obmc-host-startmin@0.target.requires"
FILES_${PN}_remove = "${systemd_unitdir}/system/obmc-host-startmin@0.target.requires/op-start-host@0.service"
FILES_${PN}_remove = "${systemd_unitdir}/system/obmc-host-startmin@0.target.requires/op-init-pnor@0.service"