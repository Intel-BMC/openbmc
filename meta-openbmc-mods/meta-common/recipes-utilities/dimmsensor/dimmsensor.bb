SUMMARY = "Dimm Sensor"
DESCRIPTION = "Dimm Sensor Executable"

SRC_URI = "\
    file://CMakeLists.txt \
    file://DimmSensor.cpp \
    "

LICENSE = "CLOSED"

S = "${WORKDIR}"

inherit cmake

# linux-libc-headers guides this way to include custom uapi headers
CXXFLAGS_append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
