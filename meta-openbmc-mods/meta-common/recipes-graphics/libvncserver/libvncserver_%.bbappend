FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
SRC_URI = "git://github.com/LibVNC/libvncserver"
SRCREV = "2b6d595e3ea89597b3bebbf545eb7d3c0a1224a8"
