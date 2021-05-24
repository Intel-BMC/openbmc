SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "f763c9e3bbe0f86a4a41e7bb0dc70bffde0af9b2"

EXTRA_OEMESON += " -Dmax-reports=5"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=5000"
