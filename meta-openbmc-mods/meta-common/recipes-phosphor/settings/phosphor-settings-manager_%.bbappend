FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-settings-initialize-data-file-with-default-setting.patch \
            "

DEPENDS += "intel-dbus-interfaces intel-dbus-interfaces-native"
RDEPENDS_${PN} += "intel-dbus-interfaces"

EXTRA_OEMAKE += "LDFLAGS='${LDFLAGS} -lintel_dbus'"
