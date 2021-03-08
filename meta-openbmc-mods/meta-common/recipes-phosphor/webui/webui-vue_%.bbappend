# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "391f94921bffb243d1eb3d72a49402a930b42160"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
