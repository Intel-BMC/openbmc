SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "9f9ff90a39219ff3a2f1179f74fc9a6dc857e5ab"

EXTRA_OEMESON += " -Dmax-reports=5"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=5000"
