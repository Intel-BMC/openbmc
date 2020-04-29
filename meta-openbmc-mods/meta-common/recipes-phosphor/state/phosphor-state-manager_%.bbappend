FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "gtest"

SYSTEMD_SERVICE_${PN}-bmc += "obmc-mapper.target"
