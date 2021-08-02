# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/pfr-manager"
SRCREV = "29b4779eb8dd444f2e70806e35ae2c398222a74d"
DEPENDS += " libgpiod \
           "
