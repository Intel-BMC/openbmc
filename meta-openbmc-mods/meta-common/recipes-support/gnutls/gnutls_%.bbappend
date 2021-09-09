FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PV = "3.7.1"

SHRT_VER = "${@d.getVar('PV').split('.')[0]}.${@d.getVar('PV').split('.')[1]}"
SRC_URI = "https://www.gnupg.org/ftp/gcrypt/gnutls/v${SHRT_VER}/gnutls-${PV}.tar.xz \
          "
SRC_URI[md5sum] = "278e1f50d79cd13727733adbf01fde8f"
SRC_URI[sha256sum] = "3777d7963eca5e06eb315686163b7b3f5045e2baac5e54e038ace9835e5cac6f"


