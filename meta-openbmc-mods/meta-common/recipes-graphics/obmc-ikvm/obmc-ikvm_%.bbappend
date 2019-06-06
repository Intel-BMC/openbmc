FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/obmc-ikvm"
SRCREV = "133bfa2d5b1b3af0b8e819b4cd210a0e1ac0445c"

SRC_URI += "file://0001-Add-flow-control-to-prevent-buffer-over-run.patch"
