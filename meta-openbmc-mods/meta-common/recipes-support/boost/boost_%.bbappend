FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Close-the-read-pipe-after-_read_error-completes.patch"
