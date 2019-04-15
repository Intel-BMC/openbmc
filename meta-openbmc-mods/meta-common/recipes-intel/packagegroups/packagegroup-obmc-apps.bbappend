# this is for image signing and signature verification
RDEPENDS_${PN}-extras += "${@bb.utils.contains('IMAGE_TYPE', 'pfr', ' phosphor-image-signing', '', d)}"
