FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI = "git://github.com/openbmc/phosphor-user-manager"
SRCREV = "736648e25eb250d1e200cea961fe75bf791f1355"


SRC_URI += " \
            file://0005-Added-suport-for-multiple-user-manager-services.patch \
           "
