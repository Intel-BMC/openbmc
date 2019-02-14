
SUMMARY = "FRB2 timer service"
DESCRIPTION = "The FRB2 timer service will monitor the mailbox register 0\
and start a watchdog for FRB2 if the data is 1(BIOS will write this value)"

SRC_URI = "\
    file://CMakeLists.txt \
    file://frb2-watchdog.cpp \
    "
PV = "0.1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${PHOSPHORBASE}/LICENSE;md5=19407077e42b1ba3d653da313f1f5b4e"

S = "${WORKDIR}"

inherit cmake
inherit pkgconfig pythonnative

DEPENDS += " \
            systemd \
            sdbusplus \
            sdbusplus-native \
            phosphor-logging \
            phosphor-dbus-interfaces \
            phosphor-dbus-interfaces-native \
            boost \
           "

RDEPENDS_${PN} += " \
                  libsystemd \
                  sdbusplus \
                  phosphor-logging \
                  phosphor-dbus-interfaces \
                  "
