# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "b0fadef1f96df99ff5eb0637527f04bc793c8d6e"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
