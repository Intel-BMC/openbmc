FILESEXTRAPATHS_append_intel-ast2600:= "${THISDIR}/files:"

# the meta-phosphor layer adds this patch, which conflicts
# with the intel layout for environment

SRC_URI_append_intel-ast2600 = " \
    file://intel.cfg \
    file://0001-Add-ast2600-intel-as-a-new-board.patch \
    file://0021-AST2600-Enable-host-searial-port-clock-configuration.patch \
    file://0003-ast2600-intel-layout-environment-addr.patch \
    "
