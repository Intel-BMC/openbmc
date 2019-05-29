# this is here just to bump faster than upstream
SRC_URI = "git://github.com/openbmc/entity-manager.git"
SRCREV = "24b01fdd5681726c71ddab73b2b9dfc89ee3de70"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN} += "python"
SRC_URI += " file://xyz.openbmc_project.CloseMuxes.service"
SYSTEMD_SERVICE_${PN} += " xyz.openbmc_project.CloseMuxes.service"

EXTRA_OECMAKE = "-DYOCTO=1 -DUSE_OVERLAYS=0"

do_install_prepend() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/scripts/CloseMuxes.py ${D}${bindir}
    install -d ${D}${base_libdir}/systemd/system
    install -m 0644 ${WORKDIR}/xyz.openbmc_project.CloseMuxes.service ${D}${base_libdir}/systemd/system
}
