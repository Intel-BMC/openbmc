SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "aa4a9dc5ccae9f210d0d63f99b22154c97e53c19"

EXTRA_OEMESON += " -Dmax-reports=10"
EXTRA_OEMESON += " -Dmax-triggers=0"
EXTRA_OEMESON += " -Dmax-append-limit=0"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=1000"
