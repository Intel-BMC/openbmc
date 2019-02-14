# add some configuration overrides for systemd default /usr/lib/tmpfiles.d/

LICENSE = "GPL-2.0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Disable udev hwdb
RRECOMMENDS_${PN}_remove += "udev-hwdb"
PACKAGES_remove += "udev-hwdb"

do_install_append() {
  rm -rf ${D}${rootlibexecdir}/udev/hwdb.d
  rm -f ${D}${sysconfdir}/udev/hwdb.bin
}
