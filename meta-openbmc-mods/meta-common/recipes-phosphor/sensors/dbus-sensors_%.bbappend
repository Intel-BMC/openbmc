SRCREV = "4316218ab824c3c60f566b38f620a6d778e45a83"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

