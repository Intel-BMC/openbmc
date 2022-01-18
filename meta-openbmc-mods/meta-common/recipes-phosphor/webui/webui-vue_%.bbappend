# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "2a2e1021f48e2a939859ba7f4ae86c5de6df5655"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://login-company-logo.svg \
    file://logo-header.svg \
    "

do_compile:prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
  cp -vf ${WORKDIR}/login-company-logo.svg ${S}/src/assets/images
  cp -vf ${WORKDIR}/logo-header.svg ${S}/src/assets/images
}
