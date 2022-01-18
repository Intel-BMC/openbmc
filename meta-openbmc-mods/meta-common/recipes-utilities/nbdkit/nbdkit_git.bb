SUMMARY = "nbdkit is a toolkit for creating NBD servers."
DESCRIPTION = "NBD — Network Block Device — is a protocol \
for accessing Block Devices (hard disks and disk-like things) \
over a Network. \
\
nbdkit is a toolkit for creating NBD servers."

HOMEPAGE = "https://github.com/libguestfs/nbdkit"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f9dcc2d8acdde215fa4bd6ac12bb14f0"

SRC_URI = "git://github.com/libguestfs/nbdkit.git;protocol=https"
SRC_URI += "file://0001-Force-nbdkit-to-send-PATCH-as-upload-method.patch"

PV = "1.28.0+git${SRCPV}"
SRCREV = "676c193ba05e479c145cf872e4912c576d1461d3"

S = "${WORKDIR}/git"

DEPENDS = "curl xz e2fsprogs zlib"

inherit pkgconfig python3native perlnative autotools
inherit autotools-brokensep

# Specify any options you want to pass to the configure script using EXTRA_OECONF:
EXTRA_OECONF = "--disable-python --disable-perl --disable-ocaml \
               --disable-rust --disable-ruby --disable-tcl \
               --disable-lua --disable-vddk --without-libvirt \
               --without-libguestfs"

do_install:append() {
    rm -f ${D}/usr/share/bash-completion/completions/nbdkit
    rmdir ${D}/usr/share/bash-completion/completions
    rmdir ${D}/usr/share/bash-completion
}
