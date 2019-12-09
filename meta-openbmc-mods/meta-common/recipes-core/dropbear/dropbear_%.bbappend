do_install_append() {
   # Remove dropbear service, if debug-tweaks is disabled
   ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '', 'rm ${D}/${systemd_unitdir}/system/dropbear@.service', d)}
}

