FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Fix-heap-buffer-overflow-in-captoinfo.patch \
            file://0002-Fix-added-to-mitigate-CVE-2022-29458.patch \
           "
