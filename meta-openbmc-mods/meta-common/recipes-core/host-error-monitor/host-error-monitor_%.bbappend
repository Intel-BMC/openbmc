# Enable downstream autobump
#SRC_URI = "git://github.com/openbmc/host-error-monitor"
SRCREV = "9a9bf9846cabf0ef4c7076776f70230e1a7b8b13"

EXTRA_OECMAKE = "-DYOCTO=1"
