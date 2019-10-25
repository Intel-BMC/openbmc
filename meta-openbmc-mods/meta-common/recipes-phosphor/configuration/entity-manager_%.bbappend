# this is here just to bump faster than upstream
SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "978fcadadc8320ff5356ed1a5dc25e3284e3745f"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

EXTRA_OECMAKE = "-DYOCTO=1 -DUSE_OVERLAYS=0"

