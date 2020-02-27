SUMMARY = "Multi-node Non-legacy"
DESCRIPTION = "New systemd target for non-legacy nodes on multi-node platform"

inherit systemd

SYSTEMD_SERVICE_${PN} = "multi-node-nl.target"
SYSTEMD_SERVICE_${PN} += "nonLegacyNode.service"

S = "${WORKDIR}"
SRC_URI = "file://multi-node-nl.target \
           file://nonLegacyNode.service \
           file://nonLegacyNode.sh \
          "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

RDEPENDS_${PN} = "bash"

do_install_append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/nonLegacyNode.sh ${D}/${bindir}/nonLegacyNode.sh

    install -d ${D}${base_libdir}/systemd/system
    install -m 0644 ${S}/multi-node-nl.target ${D}${base_libdir}/systemd/system
    install -m 0644 ${S}/nonLegacyNode.service ${D}${base_libdir}/systemd/system
}
