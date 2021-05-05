SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "d7cebdd37fade28b0efd34bb9d641135bff758a0"

EXTRA_OEMESON += " -Dmax-reports=5"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=5000"
