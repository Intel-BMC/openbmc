SRCREV = "347dd4e7a0a4923583151e4d9eb483b65dba9e7b"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod libmctp"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

