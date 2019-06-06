FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI = "git://github.com/openbmc/phosphor-user-manager"
SRCREV = "59dba4435d0d553369790e8936d7eb43251ff302"


SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
           "
