FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
SRC_URI = "git://github.com/LibVNC/libvncserver"
SRCREV = "8f6b47ddb8f224510ec50d50012b17721bea6f2d"
