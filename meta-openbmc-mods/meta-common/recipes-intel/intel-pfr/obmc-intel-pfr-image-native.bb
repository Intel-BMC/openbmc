SUMMARY = "Intel PFR image manifest and image signing keys"
DESCRIPTION = "This copies PFR image generation scripts and image signing keys to staging area"

PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${INTELBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit native

DEPENDS += " intel-blocksign-native"

SRC_URI = " \
           file://pfr_image.py \
          "

do_install () {
        bbplain "Copying intel pfr image generation scripts and image signing keys"

        install -d ${D}${bindir}
        install -d ${D}/${datadir}/pfrconfig
        install -m 775 ${WORKDIR}/pfr_image.py ${D}${bindir}/pfr_image.py
}

