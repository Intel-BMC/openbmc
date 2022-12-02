FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://CVE-2022-23308-Use-after-free-of-ID-and-IDREF.patch \
            file://CVE-2022-29824-Fix-integer-overflows-in-xmlBuf-and-xmlBuffer.patch \
           "
