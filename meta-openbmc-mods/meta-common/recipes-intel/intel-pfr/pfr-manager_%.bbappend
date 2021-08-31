# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/pfr-manager"
SRCREV = "bcc7ce1f418c1a16a7868fee62499fa677242254"
DEPENDS += " libgpiod \
           "
