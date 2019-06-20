FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/phosphor-webui.git"
SRCREV = "e4ae854c217344b4f35717e922083a253f43bfa0"

SRC_URI += "file://0004-Implement-force-boot-to-bios-in-server-power-control.patch"
