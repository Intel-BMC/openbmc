RDEPENDS_${PN}-runtime += "${MLPREFIX}pam-plugin-localuser-${libpam_suffix}"

# Default settings: lockout duration to 300 seconds and threshold value to 10.
do_install_append() {
 sed -i 's/deny=0/deny=10/' ${D}${sysconfdir}/pam.d/common-auth
 sed -i 's/unlock_time=0/unlock_time=300/' ${D}${sysconfdir}/pam.d/common-auth
}
