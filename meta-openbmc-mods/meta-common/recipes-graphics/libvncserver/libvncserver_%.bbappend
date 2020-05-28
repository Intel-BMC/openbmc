FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
SRC_URI = "git://github.com/LibVNC/libvncserver;nobranch=1"
SRCREV = "ce9ae99b370d76521add190a8ca593aa6e3114dd"
