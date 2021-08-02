# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "240c056c8989c5e3e0f0ff640f38f3e4cdbc6ac5"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
