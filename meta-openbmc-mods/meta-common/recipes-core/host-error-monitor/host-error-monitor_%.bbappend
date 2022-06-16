# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI  = "git://github.com/openbmc/host-error-monitor;branch=master;protocol=https"
SRCREV = "ed6972aefe37a039d5b41d183eafc8c48549be67"

EXTRA_OECMAKE = "-DYOCTO=1"
