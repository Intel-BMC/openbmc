# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "1915d8c4992c1a4165e8ae108e4d799b3b4ce86a"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
