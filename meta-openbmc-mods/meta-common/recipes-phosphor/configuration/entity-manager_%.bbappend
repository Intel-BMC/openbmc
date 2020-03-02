# this is here just to bump faster than upstream
SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "41622a95da34e3aacbf2b70d687d3a3a7c816c8a"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

EXTRA_OECMAKE = "-DYOCTO=1 -DUSE_OVERLAYS=0"

