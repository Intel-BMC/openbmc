inherit useradd

# TODO: This should be removed, once up-stream bump up
# issue is resolved
SRC_URI += "git://github.com/openbmc/phosphor-net-ipmid"
SRCREV = "2528dfbdfdac5e0167d6529a25ee12b556577e1a"

USERADD_PACKAGES = "${PN}"
# add a group called ipmi
GROUPADD_PARAM:${PN} = "ipmi "

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://10-nice-rules.conf \
             file://0006-Modify-dbus-namespace-of-chassis-control-for-guid.patch \
             file://0011-Remove-Get-SOL-Config-Command-from-Netipmid.patch \
             file://0012-rakp12-Add-username-to-SessionInfo-interface.patch \
           "

do_install:append() {
    mkdir -p ${D}${sysconfdir}/systemd/system/phosphor-ipmi-net@.service.d/
    install -m 0644 ${WORKDIR}/10-nice-rules.conf ${D}${sysconfdir}/systemd/system/phosphor-ipmi-net@.service.d/
}
