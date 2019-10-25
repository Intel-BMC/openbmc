
SUMMARY = "Beep code manager service"
DESCRIPTION = "The beep code manager service will provide a method for beep code"

SRC_URI = "\
    file://CMakeLists.txt \
    file://beepcode_mgr.cpp \
    "
PV = "0.1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

S = "${WORKDIR}"

SYSTEMD_SERVICE_${PN} = "beepcode-mgr.service"

inherit cmake
inherit obmc-phosphor-systemd

DEPENDS += " \
            sdbusplus \
            phosphor-logging \
            boost \
           "
