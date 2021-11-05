FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
SRC_URI = "git://github.com/LibVNC/libvncserver"
SRCREV = "b889248659efa83cadf313e10493f4c9a3ac61ad"
