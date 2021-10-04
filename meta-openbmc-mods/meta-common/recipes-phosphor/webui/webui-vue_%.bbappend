# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/webui-vue.git"
SRCREV = "bfb346946727f09d99c1710e0443dcda2e8544a5"

do_compile:prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
}
