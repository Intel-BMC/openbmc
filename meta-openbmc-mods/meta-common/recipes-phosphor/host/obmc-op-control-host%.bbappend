SYSTEMD_LINK_${PN}:remove += "../op-start-host@.service:obmc-host-startmin@0.target.requires/op-start-host@0.service"
SYSTEMD_LINK_${PN}:remove += "../op-init-pnor@.service:obmc-host-startmin@0.target.requires/op-init-pnor@0.service"

FILES:${PN}:remove = "${systemd_unitdir}/system/obmc-host-startmin@0.target.requires"
FILES:${PN}:remove = "${systemd_unitdir}/system/obmc-host-startmin@0.target.requires/op-start-host@0.service"
FILES:${PN}:remove = "${systemd_unitdir}/system/obmc-host-startmin@0.target.requires/op-init-pnor@0.service"