SRCREV = "9f9b38d89a751e70cdf61bfb3f78c05800201f95"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

