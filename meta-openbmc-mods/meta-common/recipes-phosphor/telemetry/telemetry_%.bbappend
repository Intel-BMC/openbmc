SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "92cfff44d5790b7e59930e8a6acf15751a3cd891"

EXTRA_OEMESON += " -Dmax-reports=5"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=5000"
