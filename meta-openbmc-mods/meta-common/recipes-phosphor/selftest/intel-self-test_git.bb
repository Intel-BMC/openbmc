SUMMARY = "BMC Self Test service"
DESCRIPTION = "BMC Self Test service for subsystem diagnosis failure info"

SRC_URI = "git://github.com/Intel-BMC/intel-self-test;protocol=ssh"

PV = "1.0+git${SRCPV}"
SRCREV = "d039998ad2c55aeae4191af30e15bbd3032508c1"

S = "${WORKDIR}/git"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=fa818a259cbed7ce8bc2a22d35a464fc"

inherit cmake
inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-systemd
inherit pkgconfig pythonnative

SYSTEMD_SERVICE_${PN} += "xyz.openbmc_project.selftest.service"

DEPENDS += " \
            autoconf-archive-native \
            systemd \
            sdbusplus \
            sdbusplus-native \
            phosphor-logging \
            phosphor-dbus-interfaces \
            phosphor-dbus-interfaces-native \
           "

RDEPENDS_${PN} += " \
                  libsystemd \
                  sdbusplus \
                  phosphor-logging \
                  phosphor-dbus-interfaces \
                  "

EXTRA_OECMAKE = " -DENABLE_GTEST=OFF -DCMAKE_SKIP_RPATH=ON"
