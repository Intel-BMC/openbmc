FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
#SRC_URI = "git://github.com/LibVNC/libvncserver"
SRCREV = "f12b14f275f019673b3ace8fa4d46c8a79beb388"

SRC_URI += "file://0001-rfbserver-add-a-hooking-function-to-deliver-rfbFrame.patch"
