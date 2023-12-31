FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PAM_SRC_URI += "file://pam.d/login \
               "
SRC_URI += " \
    file://CVE-2023-29383_1.patch \
    file://CVE-2023-29383_2.patch \
    "
