FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI = "git://github.com/openbmc/phosphor-user-manager"
SRCREV = "fef578960f632abacc5cd615b2bedfb3ab9ebb90"


SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
           "
