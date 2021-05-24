# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "5ed21f2d1e8b82be699a623bfdef550dfd598dbb"

do_compile_prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
