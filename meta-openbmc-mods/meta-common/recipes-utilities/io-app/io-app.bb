SUMMARY = "IO App"
DESCRIPTION = "IO application for accessing memory-mapped IO regions on the BMC"

inherit cmake

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM += "\
    file://io-app.c;beginline=2;endline=14;md5=639666a0bf40bb717b46b378297eeceb \
    "

SRC_URI = "\
    file://CMakeLists.txt \
    file://io-app.c \
    "

S = "${WORKDIR}"

