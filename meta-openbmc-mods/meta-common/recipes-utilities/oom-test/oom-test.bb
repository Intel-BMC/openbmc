SUMMARY = "OOM Test App"
DESCRIPTION = "OOM (Out Of Memory) Test Application"

inherit meson

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM += "\
    file://oom-test.c;beginline=2;endline=14;md5=5175224c8877845cb45a6461c96de64d \
    "

SRC_URI = "\
    file://meson.build;subdir=${BP} \
    file://oom-test.c;subdir=${BP} \
    "
