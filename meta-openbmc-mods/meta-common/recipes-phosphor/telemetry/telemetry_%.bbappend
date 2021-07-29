SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "4ab1d496d8a50d0466afb7f49668c40758bfe6a9"

EXTRA_OEMESON += " -Dmax-reports=10"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=1000"
