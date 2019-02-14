# this is here to keep obmc-mgr-system happy,
# power control should stop relying on the deprcated
# package then we can remove it obmc-mgr-inventory
RDEPENDS_${PN}-inventory += "obmc-mgr-inventory"
# this is for image signing and signature verification
RDEPENDS_${PN}-extras += "${@bb.utils.contains('IMAGE_TYPE', 'pfr', ' phosphor-image-signing', '', d)}"