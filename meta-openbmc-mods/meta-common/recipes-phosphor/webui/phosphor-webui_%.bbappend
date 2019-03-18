FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI += "file://0001-Implement-KVM-in-webui.patch \
            file://config.json \
            file://0007-Fix-some-page-keeps-loading-on-IE11.patch \
            "

do_compile_prepend() {
        cp -r ${WORKDIR}/config.json ${S}/
}
