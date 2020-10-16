FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Only-allow-drive-sensors-on-bus-2-for-ast2500.patch \
            file://0002-Fix-missing-threshold-de-assert-event-when-threshold.patch"
