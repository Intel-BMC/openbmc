SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "e28aa53dc1492f09a64dc9f1dbfd5b6dba06e31f"

EXTRA_OEMESON += " -Dmax-reports=10"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=1000"
