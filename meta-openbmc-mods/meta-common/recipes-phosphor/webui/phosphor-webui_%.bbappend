FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/phosphor-webui.git"
SRCREV = "a2e36e0f479d1a9fa2b6d26448d5e070aea7259b"

SRC_URI += "file://0001-Implement-KVM-in-webui.patch \
            file://config.json \
            file://0007-Fix-some-page-keeps-loading-on-IE11.patch \
            "

do_compile_prepend() {
        cp -r ${WORKDIR}/config.json ${S}/
}
