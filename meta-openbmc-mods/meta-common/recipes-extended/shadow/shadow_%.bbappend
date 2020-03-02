FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PAM_SRC_URI += "file://pam.d/login \
               "
