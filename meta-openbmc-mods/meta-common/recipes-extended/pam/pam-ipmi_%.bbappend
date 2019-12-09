do_install_append () {
# Remove ipmi_pass from image, if debug-tweaks is not enabled
    ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '', 'rm ${D}/${sysconfdir}/ipmi_pass', d)}
}
