COMPATIBLE_MACHINE_intel-ast2600 = "intel-ast2600"
KMACHINE = "aspeed"
KERNEL_DEVICETREE = " \
    ${KMACHINE}-bmc-${COMPATIBLE_MACHINE}.dtb \
    "
#KERNEL_DEVICETREE = "${KMACHINE}-ast2600-evb.dtb"

require conf/machine/include/ast2600.inc
require conf/machine/include/obmc-bsp-si-common.inc
require conf/machine/include/intel.inc

TARGET_FPU = "hard"

PREFERRED_PROVIDER_u-boot-fw-utils ?= "u-boot-fw-utils-aspeed-sdk"

UBOOT_MACHINE = "ast2600_openbmc_defconfig"
UBOOT_DEVICETREE = "ast2600-intel"

VIRTUAL-RUNTIME_skeleton_workbook = "${MACHINE}-config"

IMAGE_CLASSES += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'image_types_intel_pfr', '', d)}"
