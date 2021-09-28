SRC_URI = "git://github.com/openbmc/peci-pcie"

SRCREV = "8e96603605eebd574bb00cd35e7fa118071aeeae"

EXTRA_OECMAKE += "-DWAIT_FOR_OS_STANDBY=1 -DUSE_RDENDPOINTCFG=1"
