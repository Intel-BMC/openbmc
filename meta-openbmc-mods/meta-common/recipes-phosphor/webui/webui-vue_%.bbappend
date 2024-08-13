# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "f4328edf86b284fe8836717251ce6696670dbdd5"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://login-company-logo.svg \
    file://logo-header.svg \
    file://0001-Old-password-input-in-change-password-screen.patch \
    file://0002-Hack-webpack-to-not-use-MD4.patch \
    "

# Workaround_1 (adapted from upstream)
# Upstream commit reference: f1f90e183 webui-vue: enable network access during build
# https://github.com/openbmc/openbmc/commit/14cef4e6c4d3e206d43cc9653e479a5a331f06ab

# Network access from task are disabled by default on Yocto 3.5
# https://git.yoctoproject.org/poky/tree/documentation/migration-guides/migration-3.5.rst#n25
do_compile[network] = "1"

do_compile:prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
  cp -vf ${WORKDIR}/login-company-logo.svg ${S}/src/assets/images
  cp -vf ${WORKDIR}/logo-header.svg ${S}/src/assets/images
}
