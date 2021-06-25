FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/openbmc/phosphor-user-manager"
SRCREV = "e6500a493a156dd58a92b384c77aef2cbd3addac"

EXTRA_OECONF += "${@bb.utils.contains_any("IMAGE_FEATURES", [ 'debug-tweaks', 'allow-root-login' ], '', '--disable-root_user_mgmt', d)}"

SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
            file://0006-Use-groupmems-instead-of-getgrnam_r-due-to-overlay.patch \
           "
