FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/openbmc/phosphor-user-manager"
SRCREV = "b01e2fe760eb04ae9d0d13716a127056949e2601"

EXTRA_OECONF += "${@bb.utils.contains_any("IMAGE_FEATURES", [ 'debug-tweaks', 'allow-root-login' ], '', '--disable-root_user_mgmt', d)}"

SRC_URI += " \
             file://0001-Change-to-pam_faillock-and-pam-pwquality.patch \
             file://0005-Added-suport-for-multiple-user-manager-services.patch \
             file://0006-Use-groupmems-instead-of-getgrnam_r-due-to-overlay.patch \
           "

FILES:${PN} += "${datadir}/dbus-1/system.d/phosphor-nslcd-cert-config.conf"
FILES:${PN} += "/usr/share/phosphor-certificate-manager/nslcd"
FILES:${PN} += "\
    /lib/systemd/system/multi-user.target.wants/phosphor-certificate-manager@nslcd.service"
