FILESEXTRAPATHS_prepend := "${THISDIR}/linux-aspeed:"
SRC_URI += "file://wolfpass.cfg \
            file://0001-Create-intel-purley-dts.patch \
            file://0002-Define-the-gpio-line-names-property-for-purley-platform.patch \
            file://0003-Leave-GPIOE-in-passthrough-after-boot.patch \
            file://0004-Test-code-for-LPC-MBOX.patch \
            "
SRC_URI += "${@bb.utils.contains('IMAGE_TYPE', 'pfr', 'file://0005-128MB-flashmap-for-PFR.patch', '', d)}"
