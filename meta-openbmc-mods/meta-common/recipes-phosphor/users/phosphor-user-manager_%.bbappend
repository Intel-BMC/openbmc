FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI = "git://github.com/openbmc/phosphor-user-manager;nobranch=1"
SRCREV = "d4d655006c6179d47008d9b374debcedcc03a1c4"

EXTRA_OECONF += "${@bb.utils.contains_any("IMAGE_FEATURES", [ 'debug-tweaks', 'allow-root-login' ], '', '--disable-root_user_mgmt', d)}"

SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
            file://0006-Use-groupmems-instead-of-getgrnam_r-due-to-overlay.patch \
           "
