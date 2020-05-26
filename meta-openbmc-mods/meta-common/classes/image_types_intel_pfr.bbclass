

inherit obmc-phosphor-full-fitimage
inherit image_types_phosphor_auto
DEPENDS += "obmc-intel-pfr-image-native python3-native intel-blocksign-native"

require recipes-core/os-release/version-vars.inc

IMAGE_TYPES += "intel-pfr"

IMAGE_TYPEDEP_intel-pfr = "mtd-auto"
IMAGE_TYPES_MASKED += "intel-pfr"

# PFR images directory
PFR_IMAGES_DIR = "${DEPLOY_DIR_IMAGE}/pfr_images"

# PFR image generation script directory
PFR_SCRIPT_DIR = "${STAGING_DIR_NATIVE}${bindir}"

# PFR image config directory
PFR_CFG_DIR = "${STAGING_DIR_NATIVE}${datadir}/pfrconfig"

# Refer flash map in manifest.json for the addresses offset
PFM_OFFSET = "0x80000"

# 0x80000/1024 = 0x200 or 512, 1K Page size.
PFM_OFFSET_PAGE = "512"

# RC_IMAGE
RC_IMAGE_OFFSET = "0x02a00000"

# RC_IMAGE_PAGE= 0x02a00000/1024 = 0xA800 or 43008
RC_IMAGE_PAGE = "43008"

do_image_pfr () {
    bbplain "Generating Intel PFR compliant BMC image"

    bbplain "Build Version = ${build_version}"
    bbplain "Build Number = ${build_number}"
    bbplain "Build Hash = ${build_hash}"

    mkdir -p "${PFR_IMAGES_DIR}"
    cd "${PFR_IMAGES_DIR}"

    # python script that does the creating PFM, BMC compressed and unsigned images from BMC 128MB raw binary file.
    ${PFR_SCRIPT_DIR}/pfr_image.py ${PFR_CFG_DIR}/pfr_manifest.json ${DEPLOY_DIR_IMAGE}/image-mtd ${build_version} ${build_number} ${build_hash} ${SHA}

    # sign the PFM region
    ${PFR_SCRIPT_DIR}/blocksign -c ${PFR_CFG_DIR}/pfm_config.xml -o ${PFR_IMAGES_DIR}/pfm_signed.bin ${PFR_IMAGES_DIR}/pfm.bin -v

    # Add the signed PFM to rom image
    dd bs=1k conv=notrunc seek=${PFM_OFFSET_PAGE} if=${PFR_IMAGES_DIR}/pfm_signed.bin of=${PFR_IMAGES_DIR}/image-mtd-pfr

    # Create unsigned BMC update capsule - append with 1. pfm_signed, 2. pbc, 3. bmc compressed
    dd if=${PFR_IMAGES_DIR}/pfm_signed.bin bs=1k >> ${PFR_IMAGES_DIR}/bmc_unsigned_cap.bin

    dd if=${PFR_IMAGES_DIR}/pbc.bin bs=1k >> ${PFR_IMAGES_DIR}/bmc_unsigned_cap.bin

    dd if=${PFR_IMAGES_DIR}/bmc_compressed.bin bs=1k >> ${PFR_IMAGES_DIR}/bmc_unsigned_cap.bin

    # Sign the BMC update capsule
    ${PFR_SCRIPT_DIR}/blocksign -c ${PFR_CFG_DIR}/bmc_config.xml -o ${PFR_IMAGES_DIR}/bmc_signed_cap.bin ${PFR_IMAGES_DIR}/bmc_unsigned_cap.bin -v

    # Add the signed bmc update capsule to full rom image @ 0x2a00000
    dd bs=1k conv=notrunc seek=${RC_IMAGE_PAGE} if=${PFR_IMAGES_DIR}/bmc_signed_cap.bin of=${PFR_IMAGES_DIR}/image-mtd-pfr

    # Append date and time to all the PFR images
    mv ${PFR_IMAGES_DIR}/pfm_signed.bin ${PFR_IMAGES_DIR}/pfm_signed-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/pfm.bin ${PFR_IMAGES_DIR}/pfm-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/pbc.bin ${PFR_IMAGES_DIR}/pbc-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/bmc_compressed.bin ${PFR_IMAGES_DIR}/bmc_compressed-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/bmc_unsigned_cap.bin ${PFR_IMAGES_DIR}/bmc_unsigned_cap-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/bmc_signed_cap.bin ${PFR_IMAGES_DIR}/bmc_signed_cap-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/image-mtd-pfr ${PFR_IMAGES_DIR}/image-mtd-pfr-${DATETIME}.bin
    ln -sf ${PFR_IMAGES_DIR}/image-mtd-pfr-${DATETIME}.bin ${PFR_IMAGES_DIR}/image-mtd-pfr.bin
    ln -sf ${PFR_IMAGES_DIR}/bmc_signed_cap-${DATETIME}.bin ${PFR_IMAGES_DIR}/bmc_signed_cap.bin
}

do_image_pfr[vardepsexclude] += "DATE DATETIME"
do_image_pfr[vardeps] += "IPMI_MAJOR IPMI_MINOR IPMI_AUX13 IPMI_AUX14 IPMI_AUX15 IPMI_AUX16"
do_image_pfr[depends] += " \
                         obmc-intel-pfr-image-native:do_populate_sysroot \
                         intel-blocksign-native:do_populate_sysroot \
                         "

python() {
    product_gen = d.getVar('PRODUCT_GENERATION', True)
    if product_gen == "wht":
        d.setVar('SHA', "1")# 1- SHA256

    types = d.getVar('IMAGE_FSTYPES', True).split()

    if 'intel-pfr' in types:

        bld_ver1 = d.getVar('IPMI_MAJOR', True)
        bld_ver1 = int(bld_ver1) << 8

        bld_ver2 = d.getVar('IPMI_MINOR', True)
        bld_ver2 = int(bld_ver2)

        bld_ver = bld_ver1 | bld_ver2
        d.setVar('build_version', str(bld_ver))

        bld_num = d.getVar('IPMI_AUX13', True)

        d.setVar('build_number', bld_num)

        bld_hash1 = d.getVar('IPMI_AUX14', True)
        bld_hash2 = d.getVar('IPMI_AUX15', True)
        bld_hash3 = d.getVar('IPMI_AUX16', True)

        bld_hash1 = int(bld_hash1, 16)
        bld_hash2 = int(bld_hash2, 16)
        bld_hash3 = int(bld_hash3, 16)

        bld_hash = bld_hash3 << 16
        bld_hash |= bld_hash2 << 8
        bld_hash |= bld_hash1

        d.setVar('build_hash', str(bld_hash))

        bb.build.addtask(# task, depends_on_task, task_depends_on, d )
                'do_image_pfr',
                'do_build',
                'do_generate_auto', d)
}

