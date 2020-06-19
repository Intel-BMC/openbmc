FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRCREV = "3ab6cc280e71c1fffe53a4f3f14ea683f0e2e87e"

EXTRA_OECONF += "${@bb.utils.contains_any("IMAGE_FEATURES", [ 'debug-tweaks', 'allow-root-login' ], '', '--disable-root_user_mgmt', d)}"

SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
            file://0006-Use-groupmems-instead-of-getgrnam_r-due-to-overlay.patch \
           "
