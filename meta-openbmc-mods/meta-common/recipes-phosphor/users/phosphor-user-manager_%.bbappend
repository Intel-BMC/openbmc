FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI = "git://github.com/openbmc/phosphor-user-manager;nobranch=1"
SRCREV = "1af1223304dbf7aaecd5f238227abee95cce8b39"


SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
           "
