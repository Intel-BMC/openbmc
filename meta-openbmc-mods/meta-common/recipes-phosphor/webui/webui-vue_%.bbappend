# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "7006806d21cf8d13666524a8124b8395f2f1e156"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
