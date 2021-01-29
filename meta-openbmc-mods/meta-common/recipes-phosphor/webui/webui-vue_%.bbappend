# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "5fe1c3fed73164d4fe82ebb142cefbca72c2e706"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
