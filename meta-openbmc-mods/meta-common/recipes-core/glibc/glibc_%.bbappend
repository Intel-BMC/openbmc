FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI +=  "file://0031-iconv-Fix-incorrect-UCS4-inner-loop-bounds-BZ-26923.patch \
             file://0032-Fix-buffer-overrun-in-EUC-KR-conversion-module-BZ-24973.patch \
           "
