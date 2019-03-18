FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

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
            file://0054-Fix-User-commands-require-channel-layer-lib.patch \
            file://0055-Implement-set-front-panel-button-enables-command.patch \
            "

do_install_append(){
  install -d ${D}${includedir}/phosphor-ipmi-host
  install -d ${D}${libdir}/phosphor-ipmi-host
  install -m 0644 -D ${S}/*.h ${D}${includedir}/phosphor-ipmi-host
  install -m 0644 -D ${S}/*.hpp ${D}${includedir}/phosphor-ipmi-host
  install -m 0644 -D ${S}/utils.cpp ${D}${libdir}/phosphor-ipmi-host

}
