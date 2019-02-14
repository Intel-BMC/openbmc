inherit useradd

USERADD_PACKAGES = "${PN}"
# add a group called ipmi
GROUPADD_PARAM_${PN} = "ipmi "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0006-Modify-dbus-namespace-of-chassis-control-for-guid.patch \
             file://0007-Adding-support-for-GetSessionInfo-command.patch \
             file://0008-Sync-GetSession-Info-cmd-based-on-Upstream-review.patch \
           "

