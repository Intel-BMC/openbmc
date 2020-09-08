

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

do_image_pfr_internal () {
    local manifest_json="pfr_manifest${bld_suffix}.json"
    local pfmconfig_xml="pfm_config${bld_suffix}.xml"
    local bmcconfig_xml="bmc_config${bld_suffix}.xml"
    local pfm_signed_bin="pfm_signed${bld_suffix}.bin"
    local signed_cap_bin="bmc_signedcap${bld_suffix}.bin"
    local unsigned_cap_bin="bmc_unsigned_cap${bld_suffix}.bin"
    local unsigned_cap_align_bin="bmc_unsigned_cap${bld_suffix}.bin_aligned"
    local output_bin="image-mtd-pfr${bld_suffix}"

    # python script that does creating PFM & BMC unsigned, compressed image (from BMC 128MB raw binary file).
    ${PFR_SCRIPT_DIR}/pfr_image.py -m ${PFR_CFG_DIR}/${manifest_json} -i ${DEPLOY_DIR_IMAGE}/image-mtd -n ${build_version} -b ${build_number} \
        -h ${build_hash} -s ${SHA} -o ${output_bin}

    # sign the PFM region
    ${PFR_SCRIPT_DIR}/blocksign -c ${PFR_CFG_DIR}/${pfmconfig_xml} -o ${PFR_IMAGES_DIR}/${pfm_signed_bin} ${PFR_IMAGES_DIR}/pfm.bin -v

    # Add the signed PFM to rom image
    dd bs=1k conv=notrunc seek=${PFM_OFFSET_PAGE} if=${PFR_IMAGES_DIR}/${pfm_signed_bin} of=${PFR_IMAGES_DIR}/${output_bin}

    # Create unsigned BMC update capsule - append with 1. pfm_signed, 2. pbc, 3. bmc compressed
    dd if=${PFR_IMAGES_DIR}/${pfm_signed_bin} bs=1k >> ${PFR_IMAGES_DIR}/${unsigned_cap_bin}

    dd if=${PFR_IMAGES_DIR}/pbc.bin bs=1k >> ${PFR_IMAGES_DIR}/${unsigned_cap_bin}

    dd if=${PFR_IMAGES_DIR}/bmc_compressed.bin bs=1k >> ${PFR_IMAGES_DIR}/${unsigned_cap_bin}

    # Sign the BMC update capsule
    ${PFR_SCRIPT_DIR}/blocksign -c ${PFR_CFG_DIR}/${bmcconfig_xml} -o ${PFR_IMAGES_DIR}/${signed_cap_bin} ${PFR_IMAGES_DIR}/${unsigned_cap_bin} -v

    # Add the signed bmc update capsule to full rom image @ 0x2a00000
    dd bs=1k conv=notrunc seek=${RC_IMAGE_PAGE} if=${PFR_IMAGES_DIR}/${signed_cap_bin} of=${PFR_IMAGES_DIR}/${output_bin}

    # Rename all PFR output images by appending date and time, so that they don't meddle with subsequent call to this function.
    mv ${PFR_IMAGES_DIR}/${pfm_signed_bin}         ${PFR_IMAGES_DIR}/pfm_signed${bld_suffix}-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/${unsigned_cap_bin}       ${PFR_IMAGES_DIR}/bmc_unsigned_cap${bld_suffix}-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/${unsigned_cap_align_bin} ${PFR_IMAGES_DIR}/bmc_unsigned_cap${bld_suffix}-${DATETIME}.bin_aligned
    mv ${PFR_IMAGES_DIR}/${signed_cap_bin}         ${PFR_IMAGES_DIR}/bmc_signed_cap${bld_suffix}-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/${output_bin}             ${PFR_IMAGES_DIR}/image-mtd-pfr${bld_suffix}-${DATETIME}.bin
    # Append date and time to all 'pfr_image.py' output binaries.
    mv ${PFR_IMAGES_DIR}/pfm.bin            ${PFR_IMAGES_DIR}/pfm${bld_suffix}-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/pfm.bin_aligned    ${PFR_IMAGES_DIR}/pfm${bld_suffix}-${DATETIME}.bin_aligned
    mv ${PFR_IMAGES_DIR}/pbc.bin            ${PFR_IMAGES_DIR}/pbc${bld_suffix}-${DATETIME}.bin
    mv ${PFR_IMAGES_DIR}/bmc_compressed.bin ${PFR_IMAGES_DIR}/bmc_compressed${bld_suffix}-${DATETIME}.bin

    # Use relative links. The build process removes some of the build
    # artifacts and that makes fully qualified pathes break. Relative links
    # work because of the 'cd "${PFR_IMAGES_DIR}"' at the start of this section.
    ln -sf image-mtd-pfr${bld_suffix}-${DATETIME}.bin  ${PFR_IMAGES_DIR}/image-mtd-pfr${bld_suffix}.bin
    ln -sf image-mtd-pfr${bld_suffix}-${DATETIME}.bin  ${PFR_IMAGES_DIR}/OBMC${bld_suffix}-${@ do_get_version(d)}-pfr-full.ROM
    ln -sf bmc_signed_cap${bld_suffix}-${DATETIME}.bin ${PFR_IMAGES_DIR}/bmc_signed_cap${bld_suffix}.bin
    ln -sf bmc_signed_cap${bld_suffix}-${DATETIME}.bin ${PFR_IMAGES_DIR}/OBMC${bld_suffix}-${@ do_get_version(d)}-pfr-oob.bin
}

do_image_pfr () {
    # PFR image, additional build components information suffix.
    local bld_suffix=""

    bbplain "Generating Intel PFR compliant BMC image for '${PRODUCT_GENERATION}'"

    bbplain "Build Version = ${build_version}"
    bbplain "Build Number = ${build_number}"
    bbplain "Build Hash = ${build_hash}"
    bbplain "Build SHA = ${SHA_NAME}"

    mkdir -p "${PFR_IMAGES_DIR}"
    cd "${PFR_IMAGES_DIR}"

    # First, Build default image.
    bld_suffix=""
    do_image_pfr_internal

    if [ ${PRODUCT_GENERATION} = "wht" ]; then
        #Build additional component images also, for whitley generation, if needed.
        if ! [ -z ${BUILD_SEGD} ] && [ ${BUILD_SEGD} = "yes" ]; then
            bld_suffix="_d"
            do_image_pfr_internal
        fi
    fi
}

# Include 'do_image_pfr_internal' in 'vardepsexclude';Else Taskhash mismatch error will occur.
do_image_pfr[vardepsexclude] += "do_image_pfr_internal DATE DATETIME BUILD_SEGD"
do_image_pfr[vardeps] += "IPMI_MAJOR IPMI_MINOR IPMI_AUX13 IPMI_AUX14 IPMI_AUX15 IPMI_AUX16"
do_image_pfr[depends] += " \
                         obmc-intel-pfr-image-native:do_populate_sysroot \
                         intel-blocksign-native:do_populate_sysroot \
                         "

python() {
    product_gen = d.getVar('PRODUCT_GENERATION', True)
    if product_gen == "wht":
        d.setVar('SHA', "1")# 1- SHA256
        d.setVar('SHA_NAME', "SHA256")

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

