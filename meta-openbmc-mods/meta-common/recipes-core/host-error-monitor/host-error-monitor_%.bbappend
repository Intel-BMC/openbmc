# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/host-error-monitor"
SRCREV = "5287c02c5f96b40f0941c9c72ab29d2c7ac44a96"

EXTRA_OECMAKE = "-DYOCTO=1"
