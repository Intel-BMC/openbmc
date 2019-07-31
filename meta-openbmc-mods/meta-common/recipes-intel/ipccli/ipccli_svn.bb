SUMMARY = "ipccli"
HOMEPAGE = "https://www.intel.com"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI[md5sum] = "917092bfe4244aa4312b572c2c9c303f"
SRC_URI = "svn://ssvn.pdx.intel.com/deg/pve/csv/pythonsv/subprojects/;module=ipccli;rev=804701;protocol=https;user=etanous;pswd=Cardinal2bali!"

DEPENDS_${PN} += "python-setuptools-native"

S = "${WORKDIR}/ipccli/trunk"
inherit setuptools

BBCLASSEXTEND = "native nativesdk"
