
SUMMARY = "FRB2 timer service"
DESCRIPTION = "The FRB2 timer service will monitor the mailbox register 0\
and start a watchdog for FRB2 if the data is 1(BIOS will write this value)"

SRC_URI = "\
    file://CMakeLists.txt \
    file://frb2-watchdog.cpp \
    "
PV = "0.1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

S = "${WORKDIR}"

inherit cmake
inherit pkgconfig

DEPENDS += " \
            systemd \
            sdbusplus \
            phosphor-logging \
            phosphor-dbus-interfaces \
            boost \
           "

RDEPENDS_${PN} += " \
                  libsystemd \
                  sdbusplus \
                  phosphor-logging \
                  phosphor-dbus-interfaces \
                  "
