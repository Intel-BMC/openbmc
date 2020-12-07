FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
SRC_URI = "git://github.com/LibVNC/libvncserver"
SRCREV = "bef41f6ec4097a8ee094f90a1b34a708fbd757ec"
