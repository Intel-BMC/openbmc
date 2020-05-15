do_install_append () {
# Remove ipmi_pass from image, if debug-tweaks is not enabled
    ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '', 'rm ${D}/${sysconfdir}/ipmi_pass', d)}
}

# latest upstream HEAD until meta-phosphor autobumps
SRCREV = "c2ef3319b42d86862b479e08e652ab36a26a14db"
