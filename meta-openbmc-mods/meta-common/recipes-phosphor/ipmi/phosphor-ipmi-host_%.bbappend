FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# TODO: This should be removed, once up-stream bump up
# issue is resolved
#SRC_URI = "git://github.com/openbmc/phosphor-host-ipmid"
SRCREV = "894d022017215acceafc9e3f21379534f5396d21"

SRC_URI += "file://phosphor-ipmi-host.service \
            file://host-ipmid-whitelist.conf \
            file://0009-IPv6-Network-changes.patch \
            file://0010-fix-get-system-GUID-ipmi-command.patch \
            file://0013-ipmi-add-set-bios-id-to-whitelist.patch \
            file://0039-ipmi-add-oem-command-get-AIC-FRU-to-whitelist.patch \
            file://0050-enable-6-oem-commands.patch \
            file://0053-Fix-keep-looping-issue-when-entering-OS.patch \
            file://0056-add-SetInProgress-to-get-set-boot-option-cmd.patch \
            file://0057-Add-timer-use-actions-support.patch \
            file://0059-Move-Set-SOL-config-parameter-to-host-ipmid.patch \
            file://0060-Move-Get-SOL-config-parameter-to-host-ipmid.patch \
            file://0062-Update-IPMI-Chassis-Control-command.patch \
            file://0063-Save-the-pre-timeout-interrupt-in-dbus-property.patch \
            file://0064-Enable-watchdog-to-save-useflag-after-host-power-off.patch \
            file://0064-Update-provisioning-mode-filter-logic.patch \
            "

# remove the softpoweroff service since we do not need it
SYSTEMD_SERVICE_${PN}_remove += " \
    xyz.openbmc_project.Ipmi.Internal.SoftPowerOff.service"

SYSTEMD_LINK_${PN}_remove += " \
    ../xyz.openbmc_project.Ipmi.Internal.SoftPowerOff.service:obmc-host-shutdown@0.target.requires/xyz.openbmc_project.Ipmi.Internal.SoftPowerOff.service \
    "
FILES_${PN}_remove = " \
    ${systemd_unitdir}/system/obmc-host-shutdown@0.target.requires/ \
    ${systemd_unitdir}/system/obmc-host-shutdown@0.target.requires/xyz.openbmc_project.Ipmi.Internal.SoftPowerOff.service \
    "
do_configure_append(){
    cp -f ${WORKDIR}/host-ipmid-whitelist.conf ${S}
}

do_install_append(){
    rm -f ${D}/${bindir}/phosphor-softpoweroff
}
