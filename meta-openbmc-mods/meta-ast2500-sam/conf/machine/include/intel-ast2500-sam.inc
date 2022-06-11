KMACHINE = "aspeed"
KERNEL_DEVICETREE = " \
    ${KMACHINE}-bmc-intel-ast2500.dtb \
    ${KMACHINE}-bmc-intel-s2600wf.dtb \
    "

require conf/machine/include/ast2500.inc
require conf/machine/include/obmc-bsp-si-common.inc
require conf/machine/include/intel.inc
require conf/distro/include/phosphor-isolation.inc

UBOOT_MACHINE = "ast_g5_phy_config"

VIRTUAL-RUNTIME_skeleton_workbook = "${MACHINE}-config"
