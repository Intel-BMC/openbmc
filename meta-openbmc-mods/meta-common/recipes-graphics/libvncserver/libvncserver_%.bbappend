PACKAGECONFIG_remove = "gcrypt gnutls png sdl"

do_install_append() {
    rm -rf ${D}${libdir}/libvncclient*
}

# Use the latest to support obmc-ikvm
DEPENDS += "openssl lzo"

#SRC_URI = "git://github.com/LibVNC/libvncserver"
SRCREV = "f007b685b6c4201b445029ac3d459de38d30d94c"
S = "${WORKDIR}/git"

# Remove x11 and gtk+ that cause big image size
# Actually, these aren't needed to support obmc-ikvm
REQUIRED_DISTRO_FEATURES_remove = "x11"
DEPENDS_remove = "gtk+"
RDEPENDS_${PN}_remove = "gtk+"

FULL_OPTIMIZATION = "-Os -flto -fno-fat-lto-objects"
