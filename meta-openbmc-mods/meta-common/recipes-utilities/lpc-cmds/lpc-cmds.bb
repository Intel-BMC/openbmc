SUMMARY = "LPC tools"
DESCRIPTION = "command tool for LPC interface test on the BMC"

inherit cmake

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${PHOSPHORBASE}/LICENSE;md5=19407077e42b1ba3d653da313f1f5b4e"

SRC_URI = "\
    file://CMakeLists.txt \
    file://lpc_drv.h \
    file://lpc_cmds.c \
    "

S = "${WORKDIR}"

