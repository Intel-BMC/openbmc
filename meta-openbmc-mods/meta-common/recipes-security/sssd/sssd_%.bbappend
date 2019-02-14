inherit obmc-phosphor-systemd

FILESEXTRAPATHS_append := "${THISDIR}/files:"
SRC_URI += "file://sssd.conf \
            file://nscd.conf \
            file://locked_groups \
            file://ldb.sh \
           "

PACKAGECONFIG += " systemd "
SYSTEMD_AUTO_ENABLE = "enable"

EXTRA_OECONF += " --enable-pammoddir=${base_libdir}/security"

do_install_append() {
    # sssd creates also the /var/run link. Need to remove it to avoid conflicts
    # with the one created by base-files recipe.
    rm -rf ${D}/var/run
    install -m 600 ${WORKDIR}/locked_groups ${D}/${sysconfdir}/${BPN}
    install -m 600 ${WORKDIR}/nscd.conf ${D}/${sysconfdir}
    install -d ${D}${sysconfdir}/profile.d
    install -m 0644 ${WORKDIR}/ldb.sh ${D}${sysconfdir}/profile.d
}

FILES_${PN} += " /lib/security/pam_sss.so "

