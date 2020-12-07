# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "978807de2d5a11860b74f1f97dc0d915ee5c9a5e"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
