FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-hw-arm-aspeed-Add-an-intel-ast2500-machine-type.patch \
            file://0002-hw-arm-aspeed-Add-an-intel-ast2600-machine-type.patch \
            file://0003-Remove-clearing-aspeed-GPIO-registers.patch"

QEMU_TARGETS = "arm"
EXTRA_OECONF = " \
    --prefix=${prefix} \
    --bindir=${bindir} \
    --includedir=${includedir} \
    --libdir=${libdir} \
    --mandir=${mandir} \
    --datadir=${datadir} \
    --docdir=${docdir}/${BPN} \
    --sysconfdir=${sysconfdir} \
    --libexecdir=${libexecdir} \
    --localstatedir=${localstatedir} \
    --with-confsuffix=/${BPN} \
    --disable-strip \
    --disable-werror \
    --extra-cflags='${CFLAGS}' \
    --extra-ldflags='${LDFLAGS}' \
    --python=${HOSTTOOLS_DIR}/python3 \
    ${PACKAGECONFIG_CONFARGS} \
    "
