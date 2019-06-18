FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI = "git://github.com/openbmc/phosphor-user-manager"
SRCREV = "75b5a6fc4c0c06f43623fe0e746fd55e667dceb3"


SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
           "
