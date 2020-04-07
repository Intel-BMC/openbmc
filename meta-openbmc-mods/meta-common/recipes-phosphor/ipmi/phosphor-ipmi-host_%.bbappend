FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

# TODO: latest is breaking sensor list, needs triage before unpin
SRC_URI = "git://github.com/openbmc/phosphor-host-ipmid;nobranch=1"
SRCREV = "e7e8b8166a1c0e352ee6e0e1daa76abbff228ed6"

SRC_URI += "file://phosphor-ipmi-host.service \
            file://0010-fix-get-system-GUID-ipmi-command.patch \
            file://0053-Fix-keep-looping-issue-when-entering-OS.patch \
            file://0056-add-SetInProgress-to-get-set-boot-option-cmd.patch \
            file://0059-Move-Set-SOL-config-parameter-to-host-ipmid.patch \
            file://0060-Move-Get-SOL-config-parameter-to-host-ipmid.patch \
            file://0062-Update-IPMI-Chassis-Control-command.patch \
            file://0063-Save-the-pre-timeout-interrupt-in-dbus-property.patch \
            file://0001-Modify-Get-Lan-Configuration-IP-Address-Source-to-us.patch \
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
