# Base image class extension, inlined into every image.

# Phosphor image types
#
# New image types based on DTS partition information
#
inherit logging

# Image composition
FLASH_FULL_IMAGE ?= "fitImage-rootfs-${MACHINE}.bin"

IMAGE_BASETYPE ?= "squashfs-xz"
OVERLAY_BASETYPE ?= "jffs2"

IMAGE_TYPES += "mtd-auto"

IMAGE_TYPEDEP_mtd-auto = "${IMAGE_BASETYPE}"
IMAGE_TYPES_MASKED += "mtd-auto"

# Flash characteristics in KB unless otherwise noted
python() {
    types = d.getVar('IMAGE_FSTYPES', True).split()

    # TODO: find partition list in DTS
    d.setVar('FLASH_UBOOT_OFFSET', str(0))
    if 'intel-pfr' in types:
        d.setVar('FLASH_SIZE', str(128*1024))
        DTB_FULL_FIT_IMAGE_OFFSETS = [0xb00000]
    else:
        d.setVar('FLASH_SIZE', str(64*1024))
        DTB_FULL_FIT_IMAGE_OFFSETS = [0x80000, 0x2480000]

    d.setVar('FLASH_RUNTIME_OFFSETS', ' '.join(
        [str(int(x/1024)) for x in DTB_FULL_FIT_IMAGE_OFFSETS]
        )
    )
}

mk_nor_image() {
        image_dst="$1"
        image_size_kb=$2
        dd if=/dev/zero bs=1k count=$image_size_kb \
                | tr '\000' '\377' > $image_dst
}

do_generate_auto() {
    bbdebug 1 "do_generate_auto IMAGE_TYPES=${IMAGE_TYPES} size=${FLASH_SIZE}KB (${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.auto.mtd)"
    # Assemble the flash image
    mk_nor_image ${IMGDEPLOYDIR}/${IMAGE_NAME}.auto.mtd ${FLASH_SIZE}
    dd bs=1k conv=notrunc seek=${FLASH_UBOOT_OFFSET} \
        if=${DEPLOY_DIR_IMAGE}/u-boot.${UBOOT_SUFFIX} \
        of=${IMGDEPLOYDIR}/${IMAGE_NAME}.auto.mtd

    for OFFSET in ${FLASH_RUNTIME_OFFSETS}; do
        dd bs=1k conv=notrunc seek=${OFFSET} \
            if=${DEPLOY_DIR_IMAGE}/${FLASH_FULL_IMAGE} \
            of=${IMGDEPLOYDIR}/${IMAGE_NAME}.auto.mtd
    done

    ln ${IMGDEPLOYDIR}/${IMAGE_NAME}.auto.mtd \
        ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.auto.mtd
    ln -sf ${IMAGE_NAME}.auto.mtd ${DEPLOY_DIR_IMAGE}/image-mtd
    ln -sf ${IMAGE_NAME}.auto.mtd ${DEPLOY_DIR_IMAGE}/OBMC-${@ do_get_version(d)}.ROM
}
do_generate_auto[dirs] = "${S}/auto"
do_generate_auto[depends] += " \
        ${PN}:do_image_${@d.getVar('IMAGE_BASETYPE', True).replace('-', '_')} \
        virtual/kernel:do_deploy \
        u-boot:do_populate_sysroot \
        "

python() {
    types = d.getVar('IMAGE_FSTYPES', True).split()

    if 'mtd-auto' in types:
        bb.build.addtask(# task, depends_on_task, task_depends_on, d )
                'do_generate_auto',
                'do_build',
                'do_image_complete', d)
}
