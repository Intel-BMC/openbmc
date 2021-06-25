SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "32859b634e366a015331fb8ab62766340df9c7b8"

EXTRA_OEMESON += " -Dmax-reports=10"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=1000"
