SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "405c1e4bf8b993cb3800adead546e91b030ecb9b"

EXTRA_OEMESON += " -Dmax-reports=5"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=5000"
