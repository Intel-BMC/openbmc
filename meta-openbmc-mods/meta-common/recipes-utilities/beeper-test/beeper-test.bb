SUMMARY = "Beeper Test App"
DESCRIPTION = "Beeper Test Application for pwm-beeper"

inherit cmake

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM += "\
    file://beeper-test.cpp;beginline=2;endline=14;md5=c451359f18a13ee69602afce1588c01a \
    "

SRC_URI = "\
    file://CMakeLists.txt \
    file://beeper-test.cpp \
    "

S = "${WORKDIR}"

