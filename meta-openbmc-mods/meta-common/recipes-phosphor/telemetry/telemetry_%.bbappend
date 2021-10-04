SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "93064d8fcef2c6fde1f61c0cedacb46b21eab039"

EXTRA_OEMESON += " -Dmax-reports=10"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=1000"
