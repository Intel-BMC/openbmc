FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI = "git://github.com/openbmc/phosphor-user-manager"
SRCREV = "c3f56c50ffffe1076531eb4aad7c0a574a44841f"


SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
           "
