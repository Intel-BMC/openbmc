# this is here just to bump faster than upstream
SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "f69ee424f30946bd6f829cb04e532c2f3febb084"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

EXTRA_OECMAKE = "-DYOCTO=1 -DUSE_OVERLAYS=0"

