SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "503c158972ff74a23ead8f50138107157b46758d"

EXTRA_OEMESON += " -Dmax-reports=5"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=5000"
