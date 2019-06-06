KMACHINE = "aspeed"
KERNEL_DEVICETREE = "${KMACHINE}-bmc-intel-purley.dtb"

require conf/machine/include/ast2500.inc
require conf/machine/include/obmc-bsp-si-common.inc
require conf/machine/include/intel.inc
require conf/distro/include/phosphor-tiny.inc

UBOOT_MACHINE = "ast_g5_phy_config"

#Developer to specify the appropriate IMAGE_TYPE and FLASH_SIZE
#On Intel Whitley platforms PFR feature requires 128MB flash, default is 64MB
#IMAGE_TYPE = "default" or "pfr" or "non-pfr"
# "non-pfr" setting for future which is for BMC secure boot
#for PFR its 128MB in KBs - 128*1024=131072, for non-pfr its 64MB= 64*1024 = 65536
#pfr IMAGE_TYPE enforces the image signature verification during the image update
IMAGE_TYPE = "default"

VIRTUAL-RUNTIME_skeleton_workbook = "${MACHINE}-config"
