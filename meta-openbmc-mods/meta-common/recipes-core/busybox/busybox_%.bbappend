FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
           file://disable.cfg \
           file://enable.cfg \
           file://0001-Decompress_gunzip-Fix-Dos-if-gzip-is-corrupt-CVE-2021-28831.patch \
           "

SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks','file://dev-only.cfg','',d)}"
