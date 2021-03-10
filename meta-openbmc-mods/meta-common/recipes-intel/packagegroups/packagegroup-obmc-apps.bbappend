RDEPENDS_${PN}-extrasdevtools = "libgpiod-tools"
RDEPENDS_${PN}-chassis-state-mgmt_remove = "obmc-phosphor-power"
RDEPENDS_${PN}-devtools_remove = "ffdc"

PACKAGES_remove = "${PN}-debug-collector"

RDEPENDS_${PN}-settings = "settings"
