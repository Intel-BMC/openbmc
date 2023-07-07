FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

#Needed for ncurses_6.4 compilation.
DEPENDS += "ncurses"
