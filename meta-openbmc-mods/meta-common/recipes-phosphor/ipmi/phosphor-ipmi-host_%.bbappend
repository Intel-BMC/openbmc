FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

SRC_URI += "file://phosphor-ipmi-host.service \
            file://0010-fix-get-system-GUID-ipmi-command.patch \
            file://0053-Fix-keep-looping-issue-when-entering-OS.patch \
            file://0059-Move-Set-SOL-config-parameter-to-host-ipmid.patch \
            file://0060-Move-Get-SOL-config-parameter-to-host-ipmid.patch \
            file://0062-Update-IPMI-Chassis-Control-command.patch \
            file://0063-Save-the-pre-timeout-interrupt-in-dbus-property.patch \
            "

EXTRA_OECONF:append = " --disable-i2c-whitelist-check"
EXTRA_OECONF:append = " --enable-transport-oem=yes"
EXTRA_OECONF:append = " --disable-boot-flag-safe-mode-support"
EXTRA_OECONF:append = " --disable-ipmi-whitelist"

RDEPENDS:${PN}:remove = "clear-once"

# remove the softpoweroff service since we do not need it
SYSTEMD_SERVICE:${PN}:remove = " \
    xyz.openbmc_project.Ipmi.Internal.SoftPowerOff.service"

SYSTEMD_LINK:${PN}:remove = " \
    ../xyz.openbmc_project.Ipmi.Internal.SoftPowerOff.service:obmc-host-shutdown@0.target.requires/xyz.openbmc_project.Ipmi.Internal.SoftPowerOff.service \
    "

do_compile:prepend(){
    cp -f ${PROJECT_SRC_DIR}/transporthandler_oem.cpp ${S}
}

do_install:append(){
    rm -f ${D}/${bindir}/phosphor-softpoweroff
    rm -f ${S}/transporthandler_oem.cpp
}
