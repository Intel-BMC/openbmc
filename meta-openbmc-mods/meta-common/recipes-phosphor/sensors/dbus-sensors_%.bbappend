SRCREV = "2424cb7c9752cbecc3d133a67cf1c20f8589f2c1"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

