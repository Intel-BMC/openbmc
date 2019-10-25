SRCREV = "432d1edf7ac86f69558273307a59e4b1cf86b8a6"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " libgpiod"

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

