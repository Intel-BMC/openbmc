SUMMARY = "Set passthrough"
DESCRIPTION = "Script to enable / disable passthrough"

S = "${WORKDIR}"
SRC_URI = "file://set-passthrough.sh"

LICENSE = "CLOSED"
RDEPENDS_${PN} += "bash"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/set-passthrough.sh ${D}/${bindir}/set-passthrough.sh
}
