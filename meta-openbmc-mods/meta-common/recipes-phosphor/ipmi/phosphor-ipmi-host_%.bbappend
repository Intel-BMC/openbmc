FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# TODO: This should be removed, once up-stream bump up
# issue is resolved
#SRC_URI = "git://github.com/openbmc/phosphor-host-ipmid"
SRCREV = "55768e3548ef7476d4fdbe7be7a3ddb4d4896f14"

SRC_URI += "file://phosphor-ipmi-host.service \
            file://0002-Modify-dbus-interface-for-power-control.patch \
            file://0003-Modify-dbus-interface-for-chassis-control.patch \
            file://0009-IPv6-Network-changes.patch \
            file://0010-fix-get-system-GUID-ipmi-command.patch \
            file://0012-ipmi-set-get-boot-options.patch \
            file://0013-ipmi-add-set-bios-id-to-whitelist.patch \
            file://0014-Enable-get-device-guid-ipmi-command.patch \
            file://0016-add-better-sdbusplus-exception-handling.patch \
            file://0018-Catch-sdbusplus-exceptions-in-IPMI-net.patch \
            file://0021-Implement-IPMI-Commmand-Get-Host-Restart-Cause.patch \
            file://0039-ipmi-add-oem-command-get-AIC-FRU-to-whitelist.patch \
            file://0048-Implement-IPMI-Master-Write-Read-command.patch \
            file://0049-Fix-Unspecified-error-on-ipmi-restart-cause-command.patch \
            file://0050-enable-6-oem-commands.patch \
            file://0051-Fix-Set-LAN-Config-to-work-without-SetInProgress.patch \
            file://0053-Fix-keep-looping-issue-when-entering-OS.patch \
            file://0055-Implement-set-front-panel-button-enables-command.patch \
            file://0056-add-SetInProgress-to-get-set-boot-option-cmd.patch \
            file://0057-Add-timer-use-actions-support.patch \
            "

do_install_append(){
  install -d ${D}${includedir}/phosphor-ipmi-host
  install -d ${D}${libdir}/phosphor-ipmi-host
  install -m 0644 -D ${S}/*.h ${D}${includedir}/phosphor-ipmi-host
  install -m 0644 -D ${S}/*.hpp ${D}${includedir}/phosphor-ipmi-host
  install -m 0644 -D ${S}/utils.cpp ${D}${libdir}/phosphor-ipmi-host

}
