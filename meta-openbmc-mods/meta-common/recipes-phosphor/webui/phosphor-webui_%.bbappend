FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/phosphor-webui.git"
SRCREV = "5bd1dec7fdc8f6a3a20e6c23dc491b3d31392bc5"

SRC_URI += "file://0004-Implement-force-boot-to-bios-in-server-power-control.patch"
