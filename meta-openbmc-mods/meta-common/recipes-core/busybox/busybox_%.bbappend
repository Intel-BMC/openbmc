FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://disable.cfg"

SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks','file://dev-only.cfg','',d)}"
