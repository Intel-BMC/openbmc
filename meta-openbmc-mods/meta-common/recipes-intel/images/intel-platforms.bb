DESCRIPTION = "Image with Intel content based upon Phosphor, an OpenBMC framework."

inherit obmc-phosphor-full-fitimage
inherit obmc-phosphor-image-common
inherit obmc-phosphor-image-dev

FEATURE_PACKAGES_obmc-sensors = ""

fix_shadow_perms() {
    chgrp shadow ${IMAGE_ROOTFS}${sysconfdir}/shadow
    chmod u=rw,g+r ${IMAGE_ROOTFS}${sysconfdir}/shadow
}
ROOTFS_POSTPROCESS_COMMAND += "fix_shadow_perms ; "
