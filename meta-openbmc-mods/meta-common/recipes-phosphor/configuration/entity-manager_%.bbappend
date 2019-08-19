# this is here just to bump faster than upstream
SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "fff050a355041d2848b8a126a19a6cb81daebe6b"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

EXTRA_OECMAKE = "-DYOCTO=1 -DUSE_OVERLAYS=0"

