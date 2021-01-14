FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
SRC_URI = "git://github.com/LibVNC/libvncserver"
SRCREV = "2aa20dad4c23c18948d3f63b33f9dfec1f837729"
