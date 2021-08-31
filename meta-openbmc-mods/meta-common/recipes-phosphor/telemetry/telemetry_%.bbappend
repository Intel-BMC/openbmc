SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "a74e44f6ef7db43d38eb600fbfee152b31b30514"

EXTRA_OEMESON += " -Dmax-reports=10"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=1000"
