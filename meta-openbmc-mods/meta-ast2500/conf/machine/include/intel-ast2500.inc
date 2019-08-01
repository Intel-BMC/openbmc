KMACHINE = "aspeed"
KERNEL_DEVICETREE = "${KMACHINE}-bmc-intel-purley.dtb"

require conf/machine/include/ast2500.inc
require conf/machine/include/obmc-bsp-si-common.inc
require conf/machine/include/intel.inc
require conf/distro/include/phosphor-tiny.inc

UBOOT_MACHINE = "ast_g5_phy_config"

VIRTUAL-RUNTIME_skeleton_workbook = "${MACHINE}-config"

IMAGE_CLASSES += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'image_types_intel_pfr', '', d)}"
