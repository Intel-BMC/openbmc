# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "03dc2b7b9f0672aac84349fbc77aab55403447e0"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
