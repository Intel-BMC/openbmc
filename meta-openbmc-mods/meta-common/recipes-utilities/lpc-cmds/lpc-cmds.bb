SUMMARY = "LPC tools"
DESCRIPTION = "command tool for LPC interface test on the BMC"

inherit cmake

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

SRC_URI = "\
    file://CMakeLists.txt \
    file://lpc_drv.h \
    file://lpc_cmds.c \
    "

S = "${WORKDIR}"

