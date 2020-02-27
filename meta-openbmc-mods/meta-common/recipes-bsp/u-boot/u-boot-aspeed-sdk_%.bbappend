FILESEXTRAPATHS_append_intel-ast2600:= "${THISDIR}/files:"

# the meta-phosphor layer adds this patch, which conflicts
# with the intel layout for environment

SRC_URI_append_intel-ast2600 = " \
    file://fw_env.config \
    file://intel.cfg \
    file://0001-Add-ast2600-intel-as-a-new-board.patch \
    file://0021-AST2600-Enable-host-searial-port-clock-configuration.patch \
    file://0003-ast2600-intel-layout-environment-addr.patch \
    file://0004-Disable-crashdump-trigger-gpio.patch \
    file://0005-Ast2600-Enable-interrupt-in-u-boot.patch \
    file://0006-SPI-Quad-IO-Mode.patch \
    file://0007-ast2600-Override-OTP-strap-settings.patch \
    "
do_install_append () {
    install -m 0644 ${WORKDIR}/fw_env.config ${S}/tools/env/fw_env.config
}
