FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRCREV = "73ce773e2f94fcfdeeeb9db83a3e92429ab4a663"

EXTRA_OECONF += "${@bb.utils.contains_any("IMAGE_FEATURES", [ 'debug-tweaks', 'allow-root-login' ], '', '--disable-root_user_mgmt', d)}"

SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
            file://0006-Use-groupmems-instead-of-getgrnam_r-due-to-overlay.patch \
            file://0007-Treat-pwd-is-not-set-if-no-entry-in-shadow-for-usr.patch \
            file://0008-Remove-ldap-dependencies.patch \
           "

DEPENDS_remove = "nss-pam-ldapd"
