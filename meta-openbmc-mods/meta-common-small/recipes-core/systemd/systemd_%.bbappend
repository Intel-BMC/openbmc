# add some configuration overrides for systemd default /usr/lib/tmpfiles.d/

LICENSE = "GPL-2.0"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Disable udev hwdb
RRECOMMENDS:${PN}:remove += "udev-hwdb"
PACKAGES:remove += "udev-hwdb"

do_install:append() {
  rm -rf ${D}${rootlibexecdir}/udev/hwdb.d
  rm -f ${D}${sysconfdir}/udev/hwdb.bin
}
