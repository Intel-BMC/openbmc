FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/phosphor-webui.git"
SRCREV = "30d7c6377f70382088436c7a4830663eb522d588"

SRC_URI += "file://0004-Implement-force-boot-to-bios-in-server-power-control.patch"
