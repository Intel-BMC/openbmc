# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "6a192d526c9efebf7a614a9aa473eee62e555fc5"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://0001-Undo-the-unrelated-package-changes-from-the-axios-up.patch \
    "

do_compile:prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
