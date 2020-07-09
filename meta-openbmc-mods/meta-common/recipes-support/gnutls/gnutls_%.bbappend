FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PV = "3.6.14"

SHRT_VER = "${@d.getVar('PV').split('.')[0]}.${@d.getVar('PV').split('.')[1]}"
SRC_URI = "https://www.gnupg.org/ftp/gcrypt/gnutls/v${SHRT_VER}/gnutls-${PV}.tar.xz \
          "
SRC_URI[md5sum] = "bf70632d420e421baff482247f01dbfe"
#SRC_URI[sha256sum] =  "3847a3354dd908c5e603f490865ae10577d7ee3b5edf35e82d1ed8cfa1cf0191"
SRC_URI[sha256sum] = "5630751adec7025b8ef955af4d141d00d252a985769f51b4059e5affa3d39d63"


