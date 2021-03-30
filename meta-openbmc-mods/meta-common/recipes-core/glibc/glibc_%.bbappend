FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0032-Fix-buffer-overrun-in-EUC-KR-conversion-module-BZ-24973.patch \
            file://0033-Fix-assertion-failure-in-ISO-20220JP-3-module-bug-27256.patch \
            file://0034-Fix-double-free-in-netgroupcache-BZ-27462.patch \
           "
