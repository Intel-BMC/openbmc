DESCRIPTION = "Image with Intel content based upon Phosphor, an OpenBMC framework."

inherit obmc-phosphor-full-fitimage
inherit obmc-phosphor-image-common
inherit obmc-phosphor-image-dev

DEPENDS += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'obmc-intel-pfr-image-native', '', d)}"
DEPENDS += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'intel-pfr-manager', '', d)}"

FEATURE_PACKAGES_obmc-sensors = ""

fix_shadow_perms() {
    chgrp shadow ${IMAGE_ROOTFS}${sysconfdir}/shadow
    chmod u=rw,g+r ${IMAGE_ROOTFS}${sysconfdir}/shadow
}
ROOTFS_POSTPROCESS_COMMAND += "fix_shadow_perms ; "
