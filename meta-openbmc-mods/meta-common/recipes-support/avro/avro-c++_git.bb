SUMMARY = "Apache Avro data serialization system (C++ bindings)"
HOMEPAGE = "http://apr.apache.org/"
SECTION = "libs"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=43abf34d8b9908494f83c55d213a7f89"

DEPENDS = "boost"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

BRANCH = "master"
SRCREV = "f4e2ebaadaf6e6d99b59882233f8024243adb55d"
SRC_URI = "git://github.com/apache/avro;branch=${BRANCH} \
	   file://0001-enable-cross-compilation-and-pkgconfig.patch \ 
          "

S = "${WORKDIR}/git/lang/c++"

EXTRA_OECMAKE = "-DSNAPPY_INCLUDE_DIR='' -DYOCTO_BUILD=ON -DCMAKE_BUILD_TYPE=MinSizeRel"
inherit cmake

