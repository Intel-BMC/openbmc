
SUMMARY = "Beep code manager service"
DESCRIPTION = "The beep code manager service will provide a method for beep code"

SRC_URI = "\
    file://CMakeLists.txt \
    file://beepcode_mgr.cpp \
    "
PV = "0.1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${PHOSPHORBASE}/LICENSE;md5=19407077e42b1ba3d653da313f1f5b4e"

S = "${WORKDIR}"

SYSTEMD_SERVICE_${PN} = "beepcode-mgr.service"

inherit cmake
inherit obmc-phosphor-systemd

DEPENDS += " \
            sdbusplus \
            phosphor-logging \
            boost \
           "
