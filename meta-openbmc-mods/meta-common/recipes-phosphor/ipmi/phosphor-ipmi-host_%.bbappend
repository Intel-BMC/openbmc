FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

SRC_URI += "file://phosphor-ipmi-host.service \
            file://0010-fix-get-system-GUID-ipmi-command.patch \
            file://0053-Fix-keep-looping-issue-when-entering-OS.patch \
            file://0056-add-SetInProgress-to-get-set-boot-option-cmd.patch \
            file://0059-Move-Set-SOL-config-parameter-to-host-ipmid.patch \
            file://0060-Move-Get-SOL-config-parameter-to-host-ipmid.patch \
            file://0062-Update-IPMI-Chassis-Control-command.patch \
            file://0063-Save-the-pre-timeout-interrupt-in-dbus-property.patch \
            file://0001-Modify-Get-Lan-Configuration-IP-Address-Source-to-us.patch \
            file://0064-transporthandler-Fix-for-invalid-VLAN-id.patch \
            file://0065-apphandler-Fix-for-set-system-Info-parameter-cmd.patch \
            file://0066-apphandler-Fix-for-total-session-slots-count.patch \
            file://0067-Fix-for-get-Channel-Info-cmd-for-reserved-channels.patch \
            file://0068-Removal-of-OEM-privilege-setting-for-User.patch \
            file://0069-apphandler-Fix-for-get-system-info-command.patch \
            file://0070-minor-fix-corrected-cc-for-get-channel-access.patch \
            file://0071-chassishandler-SetSystemBootOptions-to-new-API.patch \
            file://0072-chassishandler-GetSystemBootOptions-to-new-API.patch \
            "

EXTRA_OECONF_append = " --disable-i2c-whitelist-check"
EXTRA_OECONF_append = " --enable-transport-oem=yes"
EXTRA_OECONF_append = " --disable-boot-flag-safe-mode-support"
EXTRA_OECONF_append = " --disable-ipmi-whitelist"

RDEPENDS_${PN}_remove = "clear-once"

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

do_compile_prepend(){
    cp -f ${PROJECT_SRC_DIR}/transporthandler_oem.cpp ${S}
}

do_install_append(){
    rm -f ${D}/${bindir}/phosphor-softpoweroff
    rm -f ${S}/transporthandler_oem.cpp
}
