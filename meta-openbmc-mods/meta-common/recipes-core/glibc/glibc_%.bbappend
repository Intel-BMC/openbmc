FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0034-Fix-double-free-in-netgroupcache-BZ-27462.patch \
    file://0035-Fix-build-error.patch \
    "
