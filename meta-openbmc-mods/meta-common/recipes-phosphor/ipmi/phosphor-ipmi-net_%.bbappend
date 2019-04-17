inherit useradd

# TODO: This should be removed, once up-stream bump up
# issue is resolved
#SRC_URI += "git://github.com/openbmc/phosphor-net-ipmid"
#SRCREV = "8af90ebcc552e243ae85aa9e9da1a00fbecab56c"

USERADD_PACKAGES = "${PN}"
# add a group called ipmi
GROUPADD_PARAM_${PN} = "ipmi "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0006-Modify-dbus-namespace-of-chassis-control-for-guid.patch \
             file://0007-Adding-support-for-GetSessionInfo-command.patch \
             file://0008-Sync-GetSession-Info-cmd-based-on-Upstream-review.patch \
             file://0009-Add-dbus-interface-for-sol-commands.patch \
             file://00010-Change-Authentication-Parameter.patch \
           "

