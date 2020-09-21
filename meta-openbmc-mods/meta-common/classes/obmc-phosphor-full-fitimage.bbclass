inherit uboot-sign logging

DEPENDS += "u-boot-mkimage-native"

SIGNING_KEY ?= "${STAGING_DIR_NATIVE}${datadir}/OpenBMC.priv"
INSECURE_KEY = "${@'${SIGNING_KEY}' == '${STAGING_DIR_NATIVE}${datadir}/OpenBMC.priv'}"
SIGNING_KEY_DEPENDS = "${@oe.utils.conditional('INSECURE_KEY', 'True', 'phosphor-insecure-signing-key-native:do_populate_sysroot', '', d)}"

DEPS = " ${PN}:do_image_${@d.getVar('IMAGE_BASETYPE', True).replace('-', '_')} \
              virtual/kernel:do_deploy \
              u-boot:do_populate_sysroot "

# Options for the device tree compiler passed to mkimage '-D' feature:
UBOOT_MKIMAGE_DTCOPTS ??= ""

#
# Emit the fitImage ITS header
#
# $1 ... .its filename
fitimage_emit_fit_header() {
    cat << EOF >> ${1}
/dts-v1/;

/ {
        description = "U-Boot fitImage for ${DISTRO_NAME}/${PV}/${MACHINE}";
        #address-cells = <1>;
EOF
}

#
# Emit the fitImage section bits
#
# $1 ... .its filename
# $2 ... Section bit type: imagestart - image section start
#                          confstart  - configuration section start
#                          sectend    - section end
#                          fitend     - fitimage end
#
fitimage_emit_section_maint() {
    case $2 in
    imagestart)
        cat << EOF >> ${1}

        images {
EOF
    ;;
    confstart)
        cat << EOF >> ${1}

        configurations {
EOF
    ;;
    sectend)
        cat << EOF >> ${1}
    };
EOF
    ;;
    fitend)
        cat << EOF >> ${1}
};
EOF
    ;;
    esac
}

#
# Emit the fitImage ITS kernel section
#
# $1 ... .its filename
# $2 ... Image counter
# $3 ... Path to kernel image
# $4 ... Compression type
# $5 ... Hash type
fitimage_emit_section_kernel() {

    kernel_csum="${5}"

    if [ -n "${kernel_csum}" ]; then
        hash_blk=$(cat << EOF
                        hash@1 {
                                algo = "${kernel_csum}";
                        };
EOF
        )
    fi

    ENTRYPOINT=${UBOOT_ENTRYPOINT}
    if [ -n "${UBOOT_ENTRYSYMBOL}" ]; then
        ENTRYPOINT=`${HOST_PREFIX}nm vmlinux | \
            awk '$3=="${UBOOT_ENTRYSYMBOL}" {print "0x"$1;exit}'`
    fi

    cat << EOF >> ${1}
                kernel@${2} {
                        description = "Linux kernel";
                        data = /incbin/("${3}");
                        type = "kernel";
                        arch = "${UBOOT_ARCH}";
                        os = "linux";
                        compression = "${4}";
                        load = <${UBOOT_LOADADDRESS}>;
                        entry = <${ENTRYPOINT}>;
                        ${hash_blk}
                };
EOF
}

#
# Emit the fitImage ITS DTB section
#
# $1 ... .its filename
# $2 ... Image counter
# $3 ... Path to DTB image
# $4 ... Hash type
fitimage_emit_section_dtb() {

    dtb_csum="${4}"
    if [ -n "${dtb_csum}" ]; then
        hash_blk=$(cat << EOF
                        hash@1 {
                                algo = "${dtb_csum}";
                        };
EOF
        )
    fi

    cat << EOF >> ${1}
                fdt@${2} {
                        description = "Flattened Device Tree blob";
                        data = /incbin/("${3}");
                        type = "flat_dt";
                        arch = "${UBOOT_ARCH}";
                        compression = "none";
                        ${hash_blk}
                };
EOF
}

#
# Emit the fitImage ITS setup section
#
# $1 ... .its filename
# $2 ... Image counter
# $3 ... Path to setup image
# $4 ... Hash type
fitimage_emit_section_setup() {

    setup_csum="${4}"
    if [ -n "${setup_csum}" ]; then
        hash_blk=$(cat << EOF
                        hash@1 {
                                algo = "${setup_csum}";
                        };
EOF
        )
    fi

    cat << EOF >> ${1}
                setup@${2} {
                        description = "Linux setup.bin";
                        data = /incbin/("${3}");
                        type = "x86_setup";
                        arch = "${UBOOT_ARCH}";
                        os = "linux";
                        compression = "none";
                        load = <0x00090000>;
                        entry = <0x00090000>;
                        ${hash_blk}
                };
EOF
}

#
# Emit the fitImage ITS ramdisk section
#
# $1 ... .its filename
# $2 ... Image counter
# $3 ... Path to ramdisk image
# $4 ... Hash type
fitimage_emit_section_ramdisk() {

    ramdisk_csum="${4}"
    if [ -n "${ramdisk_csum}" ]; then
        hash_blk=$(cat << EOF
                        hash@1 {
                                algo = "${ramdisk_csum}";
                        };
EOF
        )
    fi
    ramdisk_ctype="none"
    ramdisk_loadline=""
    ramdisk_entryline=""

    if [ -n "${UBOOT_RD_LOADADDRESS}" ]; then
        ramdisk_loadline="load = <${UBOOT_RD_LOADADDRESS}>;"
    fi
    if [ -n "${UBOOT_RD_ENTRYPOINT}" ]; then
        ramdisk_entryline="entry = <${UBOOT_RD_ENTRYPOINT}>;"
    fi

    case $3 in
        *.gz)
            ramdisk_ctype="gzip"
            ;;
        *.bz2)
            ramdisk_ctype="bzip2"
            ;;
        *.lzma)
            ramdisk_ctype="lzma"
            ;;
        *.lzo)
            ramdisk_ctype="lzo"
            ;;
        *.lz4)
            ramdisk_ctype="lz4"
            ;;
    esac

    cat << EOF >> ${1}
                ramdisk@${2} {
                        description = "${INITRAMFS_IMAGE}";
                        data = /incbin/("${3}");
                        type = "ramdisk";
                        arch = "${UBOOT_ARCH}";
                        os = "linux";
                        compression = "${ramdisk_ctype}";
                        ${ramdisk_loadline}
                        ${ramdisk_entryline}
                        ${hash_blk}
                };
EOF
}

#
# Emit the fitImage ITS configuration section
#
# $1 ... .its filename
# $2 ... Linux kernel ID
# $3 ... DTB image name
# $4 ... ramdisk ID
# $5 ... config ID
# $6 ... default flag
# $7 ... Hash type
# $8 ... DTB index
fitimage_emit_section_config() {

    conf_csum="${7}"
    if [ -n "${conf_csum}" ]; then
        hash_blk=$(cat << EOF
                        hash@1 {
                                algo = "${conf_csum}";
                        };
EOF
        )
    fi
    if [ -n "${UBOOT_SIGN_ENABLE}" ] ; then
        conf_sign_keyname="${UBOOT_SIGN_KEYNAME}"
    fi

    # Test if we have any DTBs at all
    conf_desc="Linux kernel"
    kernel_line="kernel = \"kernel@${2}\";"
    fdt_line=""
    ramdisk_line=""
    setup_line=""
    default_line=""

    if [ -n "${3}" ]; then
        conf_desc="${conf_desc}, FDT blob"
        fdt_line="fdt = \"fdt@${3}\";"
    fi

    if [ -n "${4}" ]; then
        conf_desc="${conf_desc}, ramdisk"
        ramdisk_line="ramdisk = \"ramdisk@${4}\";"
    fi

    if [ -n "${5}" ]; then
        conf_desc="${conf_desc}, setup"
        setup_line="setup = \"setup@${5}\";"
    fi

    if [ "${6}" = "1" ]; then
        default_line="default = \"conf@${3}\";"
    fi

    cat << EOF >> ${1}
                ${default_line}
                conf@${3} {
                        description = "${6} ${conf_desc}";
                        ${kernel_line}
                        ${fdt_line}
                        ${ramdisk_line}
                        ${setup_line}
                        ${hash_blk}
EOF

    if [ ! -z "${conf_sign_keyname}" ] ; then

        sign_line="sign-images = \"kernel\""

        if [ -n "${3}" ]; then
            sign_line="${sign_line}, \"fdt\""
        fi

        if [ -n "${4}" ]; then
            sign_line="${sign_line}, \"ramdisk\""
        fi

        if [ -n "${5}" ]; then
            sign_line="${sign_line}, \"setup\""
        fi

        sign_line="${sign_line};"

        cat << EOF >> ${1}
                        signature@1 {
                                algo = "${conf_csum},rsa2048";
                                key-name-hint = "${conf_sign_keyname}";
                                ${sign_line}
                        };
EOF
    fi

    cat << EOF >> ${1}
                };
EOF
}

#
# Assemble fitImage
#
# $1 ... .its filename
# $2 ... fitImage name
# $3 ... include rootfs
fitimage_assemble() {
    kernelcount=1
    dtbcount=""
    DTBS=""
    ramdiskcount=${3}
    setupcount=""
    #hash_type="sha256"
    hash_type=""
    rm -f ${1} ${2}

    #
    # Step 0: find the kernel image in the deploy/images/$machine dir
    #
    KIMG=""
    for KTYPE in zImage bzImage vmlinuz; do
        if [ -e "${DEPLOY_DIR_IMAGE}/${ktype}" ]; then
            KIMG="${DEPLOY_DIR_IMAGE}/${KTYPE}"
            break
        fi
    done
    if [ -z "${KIMG}" ]; then
        bbdebug 1 "Failed to find kernel image to pack into full fitimage"
        return 1
    fi

    fitimage_emit_fit_header ${1}

    #
    # Step 1: Prepare a kernel image section.
    #
    fitimage_emit_section_maint ${1} imagestart

    fitimage_emit_section_kernel ${1} "${kernelcount}" "${KIMG}" "none" "${hash_type}"

    #
    # Step 2: Prepare a DTB image section
    #
    if [ -n "${KERNEL_DEVICETREE}" ]; then
        dtbcount=1
        for DTB in ${KERNEL_DEVICETREE}; do
            if echo ${DTB} | grep -q '/dts/'; then
                bberror "${DTB} contains the full path to the the dts file, but only the dtb name should be used."
                DTB=`basename ${DTB} | sed 's,\.dts$,.dtb,g'`
            fi
            DTB_PATH="${DEPLOY_DIR_IMAGE}/${DTB}"
            if [ ! -e "${DTB_PATH}" ]; then
                bbwarn "${DTB_PATH} does not exist"
                continue
            fi

            DTB=$(echo "${DTB}" | tr '/' '_')
            DTBS="${DTBS} ${DTB}"
            fitimage_emit_section_dtb ${1} ${DTB} ${DTB_PATH} "${hash_type}"
        done
    fi

    #
    # Step 3: Prepare a setup section. (For x86)
    #
    if [ -e arch/${ARCH}/boot/setup.bin ]; then
        setupcount=1
        fitimage_emit_section_setup ${1} "${setupcount}" arch/${ARCH}/boot/setup.bin "${hash_type}"
    fi

    #
    # Step 4: Prepare a ramdisk section.
    #
    if [ "x${ramdiskcount}" = "x1" ] ; then
        bbdebug 1 "searching for requested rootfs"
        # Find and use the first initramfs image archive type we find
        for img in squashfs-lz4 squashfs-xz squashfs cpio.lz4 cpio.lzo cpio.lzma cpio.xz cpio.gz cpio; do
            initramfs_path="${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}-${MACHINE}.${img}"
            bbdebug 1 "looking for ${initramfs_path}"
            if [ -e "${initramfs_path}" ]; then
                bbdebug 1 "Found ${initramfs_path}"
                fitimage_emit_section_ramdisk ${1} "${ramdiskcount}" "${initramfs_path}" "${hash_type}"
                break
            fi
        done
    fi

    fitimage_emit_section_maint ${1} sectend

    # Force the first Kernel and DTB in the default config
    kernelcount=1
    if [ -n "${dtbcount}" ]; then
        dtbcount=1
    fi

    #
    # Step 5: Prepare a configurations section
    #
    fitimage_emit_section_maint ${1} confstart

    if [ -n "${DTBS}" ]; then
        i=1
        for DTB in ${DTBS}; do
            fitimage_emit_section_config ${1} "${kernelcount}" "${DTB}" "${ramdiskcount}" "${setupcount}" "`expr ${i} = ${dtbcount}`" "${hash_type}" "${i}"
            i=`expr ${i} + 1`
        done
    fi

    fitimage_emit_section_maint ${1} sectend

    fitimage_emit_section_maint ${1} fitend

    #
    # Step 6: Assemble the image
    #
    uboot-mkimage \
        ${@'-D "${UBOOT_MKIMAGE_DTCOPTS}"' if len('${UBOOT_MKIMAGE_DTCOPTS}') else ''} \
        -f ${1} ${2}

    #
    # Step 7: Sign the image and add public key to U-Boot dtb
    #
    if [ "x${UBOOT_SIGN_ENABLE}" = "x1" ] ; then
        uboot-mkimage \
            ${@'-D "${UBOOT_MKIMAGE_DTCOPTS}"' if len('${UBOOT_MKIMAGE_DTCOPTS}') else ''} \
            -F -k "${UBOOT_SIGN_KEYDIR}" \
            -K "${DEPLOY_DIR_IMAGE}/${UBOOT_DTB_BINARY}" \
            -r ${2}
    fi
}

python do_generate_phosphor_manifest() {
    import os.path
    b = d.getVar('B', True)
    manifest_filename = os.path.join(b, "MANIFEST")
    version = do_get_version(d)
    with open(manifest_filename, 'w') as fd:
        fd.write('purpose=xyz.openbmc_project.Software.Version.VersionPurpose.BMC\n')
        fd.write('version={}\n'.format(version.strip('"')))
        fd.write('KeyType={}\n'.format("OpenBMC"))
        fd.write('HashType=RSA-SHA256\n')
}

# Get HEAD git hash
def get_head_hash(codebase):
    err = None
    try:
        cmd = 'git --work-tree {} --git-dir {}/.git {}'.format(codebase, codebase, "rev-parse HEAD")
        ret, err = bb.process.run(cmd)
        if err is not None:
            ret += err
    except bb.process.ExecutionError as e:
        ret = ''
        if e.stdout is not None:
            ret += e.stdout
        if e.stderr is not None:
            ret += e.stderr
    except Exception as e:
        ret = str(e)
    return ret.split("\n")[0]

# Generate file 'RELEASE'
# It contains git hash info which is required by rest of release process (release note, for example)
python do_generate_release_metainfo() {
    b        = d.getVar('DEPLOY_DIR_IMAGE', True)
    corebase = d.getVar('COREBASE', True)
    intelbase = os.path.join(corebase, 'meta-openbmc-mods')
    filename  = os.path.join(b, "RELEASE")
    version   = do_get_version(d)

    with open(filename, 'w') as fd:
        fd.write('VERSION_ID={}\n'.format(version.strip('"')))
        if os.path.exists(corebase):
            obmc_hash = get_head_hash(corebase)
            fd.write('COMMUNITY_HASH={}\n'.format(obmc_hash))
        if os.path.exists(intelbase):
            intel_hash = get_head_hash(intelbase)
            fd.write('INTEL_HASH={}\n'.format(intel_hash))
}

def get_pubkey_type(d):
    return os.listdir(get_pubkey_basedir(d))[0]

def get_pubkey_path(d):
    return os.path.join(
        get_pubkey_basedir(d),
        get_pubkey_type(d),
        'publickey')
python do_copy_signing_pubkey() {
    with open(get_pubkey_path(d), 'r') as read_fd:
        with open('publickey', 'w') as write_fd:
            write_fd.write(read_fd.read())
}

do_copy_signing_pubkey[dirs] = "${S}"
do_copy_signing_pubkey[depends] += " \
        phosphor-image-signing:do_populate_sysroot \
        "

do_image_fitimage_rootfs() {
    bbdebug 1 "check for rootfs phosphor fitimage"
    cd ${B}
    bbdebug 1 "building rootfs phosphor fitimage"
    fitimage_assemble fitImage-rootfs-${MACHINE}-${DATETIME}.its \
        fitImage-rootfs-${MACHINE}-${DATETIME}.bin 1

    for SFX in its bin; do
        SRC="fitImage-rootfs-${MACHINE}-${DATETIME}.${SFX}"
        SYM="fitImage-rootfs-${MACHINE}.${SFX}"
        if [ -e "${B}/${SRC}" ]; then
            install -m 0644 "${B}/${SRC}" "${DEPLOY_DIR_IMAGE}/${SRC}"
            ln -sf "${SRC}" "${DEPLOY_DIR_IMAGE}/${SYM}"
        fi
    done
    ln -sf "${DEPLOY_DIR_IMAGE}/fitImage-rootfs-${MACHINE}.bin" "image-runtime"
    # build a tarball with the right parts: MANIFEST, signatures, etc.
    # create a directory for the tarball
    mkdir -p "${B}/img"
    cd "${B}/img"
    # add symlinks for the contents
    ln -sf "${DEPLOY_DIR_IMAGE}/u-boot.${UBOOT_SUFFIX}" "image-u-boot"
    ln -sf "${DEPLOY_DIR_IMAGE}/fitImage-rootfs-${MACHINE}.bin" "image-runtime"
    # add the manifest
    bbdebug 1 "Manifest file: ${B}/MANIFEST"
    ln -sf ${B}/MANIFEST .
    # touch the required files to minimize change
    touch image-kernel image-rofs image-rwfs

    tar -h -cvf "${DEPLOY_DIR_IMAGE}/${PN}-image-update-${MACHINE}-${DATETIME}.tar" MANIFEST image-u-boot image-runtime image-kernel image-rofs image-rwfs
    # make a symlink
    ln -sf "${PN}-image-update-${MACHINE}-${DATETIME}.tar" "${DEPLOY_DIR_IMAGE}/image-update-${MACHINE}"
    ln -sf "${PN}-image-update-${MACHINE}-${DATETIME}.tar" "${DEPLOY_DIR_IMAGE}/OBMC-${@ do_get_version(d)}-oob.bin"
    ln -sf "image-update-${MACHINE}" "${DEPLOY_DIR_IMAGE}/image-update"
    ln -sf "image-update-${MACHINE}" "${DEPLOY_DIR_IMAGE}/OBMC-${@ do_get_version(d)}-inband.bin"
}

do_image_fitimage_rootfs[vardepsexclude] = "DATETIME"
do_image_fitimage_rootfs[depends] += " ${DEPS}"


addtask do_image_fitimage_rootfs before do_generate_auto after do_image_complete
addtask do_generate_phosphor_manifest before do_image_fitimage_rootfs after do_image_complete
addtask do_generate_release_metainfo before do_generate_phosphor_manifest after do_image_complete
