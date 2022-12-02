FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://fw_env.config \
    file://CVE-2022-34835.patch \
    "
