FILESEXTRAPATHS_prepend_wolfpass := "${THISDIR}/${PN}:"
OBMC_CONSOLE_HOST_TTY = "ttyS2"
SRC_URI += "file://sol-option-check.sh"

do_install_append() {
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/sol-option-check.sh ${D}${bindir}
}
