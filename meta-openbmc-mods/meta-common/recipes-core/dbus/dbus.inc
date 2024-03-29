inherit autotools pkgconfig gettext upstream-version-is-even

LICENSE = "AFL-2.1 | GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=10dded3b58148f3f1fd804b26354af3e \
                    file://dbus/dbus.h;beginline=6;endline=20;md5=7755c9d7abccd5dbd25a6a974538bb3c"

SRC_URI = "https://dbus.freedesktop.org/releases/dbus/dbus-${PV}.tar.gz \
           file://tmpdir.patch \
           file://dbus-1.init \
           file://clear-guid_from_server-if-send_negotiate_unix_f.patch \
           file://stop_using_selinux_set_mapping.patch \
"

SRC_URI[md5sum] = "28d92a7a576f7feec7ddb3bb87b28b43"
SRC_URI[sha256sum] = "9da1e3f2b73f75eec0a9e4509d64be43909d1f2853fe809528a0a53984d76420"

EXTRA_OECONF = "--disable-xml-docs \
                --disable-doxygen-docs \
                --enable-largefile \
                --with-system-socket=/run/dbus/system_bus_socket \
                "
EXTRA_OECONF:append:class-target = " SYSTEMCTL=${base_bindir}/systemctl"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'systemd x11', d)} \
                   user-session \
                  "
PACKAGECONFIG:class-native = ""
PACKAGECONFIG:class-nativesdk = ""

PACKAGECONFIG[systemd] = "--enable-systemd --with-systemdsystemunitdir=${systemd_system_unitdir},--disable-systemd --without-systemdsystemunitdir,systemd"
PACKAGECONFIG[x11] = "--with-x --enable-x11-autolaunch,--without-x --disable-x11-autolaunch, virtual/libx11 libsm"
PACKAGECONFIG[user-session] = "--enable-user-session --with-systemduserunitdir=${systemd_user_unitdir},--disable-user-session"
PACKAGECONFIG[verbose-mode] = "--enable-verbose-mode,,,"
PACKAGECONFIG[audit] = "--enable-libaudit,--disable-libaudit,audit"
PACKAGECONFIG[selinux] = "--enable-selinux,--disable-selinux,libselinux"
