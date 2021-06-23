# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "71114feb9a800d42f6eeddfa477077a8ab8e44f6"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
