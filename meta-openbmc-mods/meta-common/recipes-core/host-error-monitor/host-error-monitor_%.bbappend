# Enable downstream autobump
#SRC_URI = "git://github.com/openbmc/host-error-monitor"
SRCREV = "2fbb9eadeda2ae8a77ac53346b53f2d0a72f3e74"

EXTRA_OECMAKE = "-DYOCTO=1"
