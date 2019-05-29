FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/phosphor-webui.git"
SRCREV = "44da471fceb3790b49a43bc023781f62b19f9fde"

SRC_URI += "file://0004-Implement-force-boot-to-bios-in-server-power-control.patch"
