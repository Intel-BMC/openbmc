FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " file://dev_id.json \
             file://channel_access.json \
             file://channel_config.json \
             file://master_write_read_white_list.json \
           "

FILES_${PN} += " \
    ${datadir}/ipmi-providers/channel_access.json \
    ${datadir}/ipmi-providers/channel_config.json \
    ${datadir}/ipmi-providers/master_write_read_white_list.json \
    "

do_install_append() {
    install -m 0644 -D ${WORKDIR}/channel_access.json \
        ${D}${datadir}/ipmi-providers/channel_access.json
    install -m 0644 -D ${WORKDIR}/channel_config.json \
        ${D}${datadir}/ipmi-providers/channel_config.json
    install -m 0644 -D ${WORKDIR}/master_write_read_white_list.json \
        ${D}${datadir}/ipmi-providers/master_write_read_white_list.json
}
