inherit useradd

# TODO: This should be removed, once up-stream bump up
# issue is resolved
#SRC_URI += "git://github.com/openbmc/phosphor-net-ipmid"
#SRCREV = "052b7cf37411a1bb69af1e6ce541a16021fffa9f"

USERADD_PACKAGES = "${PN}"
# add a group called ipmi
GROUPADD_PARAM_${PN} = "ipmi "

# Default rmcpp iface is eth0; channel 1
# Add channel 2 instance (eth1)
RMCPP_EXTRA = "eth1"
SYSTEMD_SERVICE_${PN} += " \
        ${PN}@${RMCPP_EXTRA}.service \
        ${PN}@${RMCPP_EXTRA}.socket \
        "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://0006-Modify-dbus-namespace-of-chassis-control-for-guid.patch \
             file://0007-Adding-support-for-GetSessionInfo-command.patch \
             file://0008-Sync-GetSession-Info-cmd-based-on-Upstream-review.patch \
             file://0009-Add-dbus-interface-for-sol-commands.patch \
             file://00010-Change-Authentication-Parameter.patch \
             file://0011-Remove-Get-SOL-Config-Command-from-Netipmid.patch \
           "

