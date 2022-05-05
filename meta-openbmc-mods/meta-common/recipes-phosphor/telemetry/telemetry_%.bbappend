SRC_URI = "git://github.com/openbmc/telemetry.git"
SRCREV = "51f0fd501f4b772533271d15cb27d396186a7192"

EXTRA_OEMESON += " -Dmax-reports=10"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=1000"
