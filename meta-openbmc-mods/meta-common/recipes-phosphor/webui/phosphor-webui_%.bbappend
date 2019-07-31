FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/phosphor-webui.git"
SRCREV = "ae0353989abe7d9194dba47ca26d803fe11f46b6"

SRC_URI += "file://0004-Implement-force-boot-to-bios-in-server-power-control.patch"
