SUMMARY = "OpenBMC VNC server and ipKVM daemon"
DESCRIPTION = "obmc-ikvm is a vncserver for JPEG-serving V4L2 devices to allow ipKVM"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=75859989545e37968a99b631ef42722e"

DEPENDS = " libvncserver sdbusplus sdbusplus-native phosphor-logging phosphor-dbus-interfaces autoconf-archive-native"

SRC_URI = "git://github.com/openbmc/obmc-ikvm"
SRCREV = "fb6a8e1e727a8ece5eb0350d3962dd3056a6f608"

PR = "r1"
PR_append = "+gitr${SRCPV}"

SYSTEMD_SERVICE_${PN} += "start-ipkvm.service"

S = "${WORKDIR}/git"

inherit autotools pkgconfig obmc-phosphor-systemd
