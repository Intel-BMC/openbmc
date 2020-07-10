FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PV = "1.12.18"

SRC_URI = "https://dbus.freedesktop.org/releases/dbus/dbus-${PV}.tar.gz \
           file://tmpdir.patch \
           file://dbus-1.init \
           file://clear-guid_from_server-if-send_negotiate_unix_f.patch \
          "
SRC_URI[md5sum] = "4ca570c281be35d0b30ab83436712242"
SRC_URI[sha256sum] = "64cf4d70840230e5e9bc784d153880775ab3db19d656ead8a0cb9c0ab5a95306"
