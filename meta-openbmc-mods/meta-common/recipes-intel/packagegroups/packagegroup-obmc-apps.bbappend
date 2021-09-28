RDEPENDS:${PN}-extrasdevtools = "libgpiod-tools"
RDEPENDS:${PN}-chassis-state-mgmt:remove = "obmc-phosphor-power"
RDEPENDS:${PN}-devtools:remove = "ffdc"

PACKAGES:remove = "${PN}-debug-collector"

RDEPENDS:${PN}-settings = "settings"
