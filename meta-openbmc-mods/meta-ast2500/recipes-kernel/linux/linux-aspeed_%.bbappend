FILESEXTRAPATHS_prepend := "${THISDIR}/linux-aspeed:"
SRC_URI += "file://intel-ast2500.cfg \
            file://0001-arm-dts-add-DTS-for-Intel-platforms.patch \
            file://0002-Enable-pass-through-on-GPIOE1-and-GPIOE3-free.patch \
            file://0003-Enable-GPIOE0-and-GPIOE2-pass-through-by-default.patch \
            file://0004-Test-code-for-LPC-MBOX.patch \
            file://0006-Allow-monitoring-of-power-control-input-GPIOs.patch \
            "
SRC_URI += "${@bb.utils.contains('IMAGE_TYPE', 'pfr', 'file://0005-128MB-flashmap-for-PFR.patch', '', d)}"
