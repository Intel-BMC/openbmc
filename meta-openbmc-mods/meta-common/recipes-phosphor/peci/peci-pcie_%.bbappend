SRC_URI = "git://github.com/openbmc/peci-pcie"

SRCREV = "bb5efe7b3ecfd56584cef10739b3395ef3017dd4"

EXTRA_OECMAKE += "-DWAIT_FOR_OS_STANDBY=1 -DUSE_RDENDPOINTCFG=1"
