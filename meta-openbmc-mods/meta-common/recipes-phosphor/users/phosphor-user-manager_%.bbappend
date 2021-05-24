FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/openbmc/phosphor-user-manager"
SRCREV = "18c1b42c1612e0e8d8f5cd9973bba09b447c7185"

EXTRA_OECONF += "${@bb.utils.contains_any("IMAGE_FEATURES", [ 'debug-tweaks', 'allow-root-login' ], '', '--disable-root_user_mgmt', d)}"

SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
            file://0006-Use-groupmems-instead-of-getgrnam_r-due-to-overlay.patch \
           "
