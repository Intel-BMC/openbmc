FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://enable-ssh.sh"

add_manual_ssh_enable() {
   install -d ${D}/usr/share/misc
   install -m 0755 ${D}/${systemd_unitdir}/system/dropbear@.service ${D}/usr/share/misc/dropbear@.service
   install -m 0755 ${D}/${systemd_unitdir}/system/dropbear.socket ${D}/usr/share/misc/dropbear.socket
   install -m 0755 ${WORKDIR}/enable-ssh.sh ${D}${bindir}/enable-ssh.sh
   # Remove dropbear service and socket by default, if debug-tweaks is disabled
   rm ${D}/${systemd_unitdir}/system/dropbear@.service
   rm ${D}/${systemd_unitdir}/system/dropbear.socket
}

do_install_append() {
   # Add manual ssh enable script if debug-tweaks is disabled
   ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '', 'add_manual_ssh_enable', d)}
}

FILES_${PN} += "/usr/share/misc"
SYSTEMD_SERVICE_${PN} += "dropbearkey.service"
SYSTEMD_SERVICE_${PN}_remove += " ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '', 'dropbear.socket', d)}"
