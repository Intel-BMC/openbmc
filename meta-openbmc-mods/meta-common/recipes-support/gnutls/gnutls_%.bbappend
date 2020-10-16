FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PV = "3.6.15"

SHRT_VER = "${@d.getVar('PV').split('.')[0]}.${@d.getVar('PV').split('.')[1]}"
SRC_URI = "https://www.gnupg.org/ftp/gcrypt/gnutls/v${SHRT_VER}/gnutls-${PV}.tar.xz \
          "
SRC_URI[md5sum] = "e80e0d20a8bb337a15fa63caa7f67006"
#SRC_URI[sha256sum] =  "3847a3354dd908c5e603f490865ae10577d7ee3b5edf35e82d1ed8cfa1cf0191"
SRC_URI[sha256sum] = "0ea8c3283de8d8335d7ae338ef27c53a916f15f382753b174c18b45ffd481558"


