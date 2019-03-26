PACKAGECONFIG_remove = "gcrypt gnutls png sdl zlib"

TARGET_CXXFLAGS += " -Dflto"

do_install_append() {
    rm -rf ${D}${libdir}/libvncclient*
}

inherit cmake

# Use the latest to support obmc-ikvm
DEPENDS += "openssl lzo"
SRC_URI = "git://github.com/LibVNC/libvncserver"
SRCREV = "3348a7e42e86dfb98dd7458ad29def476cf6096f"
S = "${WORKDIR}/git"

# Remove x11 and gtk+ that cause big image size
# Actually, these aren't needed to support obmc-ikvm
REQUIRED_DISTRO_FEATURES_remove = "x11"
DEPENDS_remove = "gtk+"
RDEPENDS_${PN}_remove = "gtk+"
