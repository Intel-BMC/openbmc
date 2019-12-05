inherit useradd

# TODO: This should be removed, once up-stream bump up
# issue is resolved
SRC_URI += "git://github.com/openbmc/phosphor-net-ipmid"
SRCREV = "49a94b2f82fb1aa68d608f28c4863bb36661a3a4"

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
             file://0009-Add-dbus-interface-for-sol-commands.patch \
             file://0011-Remove-Get-SOL-Config-Command-from-Netipmid.patch \
             file://0012-Do-not-stop-session-in-deactivate-payload.patch \
           "

