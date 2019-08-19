FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/obmc-ikvm"
SRCREV = "95a3b35bf30f730d2bc512bd42aea45746c625e6"

SRC_URI += "file://0001-Add-flow-control-to-prevent-buffer-over-run.patch"
