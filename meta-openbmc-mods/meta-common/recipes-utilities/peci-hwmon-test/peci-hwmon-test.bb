SUMMARY = "PECI hwmon test tool"
DESCRIPTION = "command line python tool for testing PECI hwmon"

SRC_URI = "\
    file://peci-hwmon-test.py \
    "
LICENSE = "CLOSED"

RDEPENDS_${PN} += "python"

S = "${WORKDIR}"

do_compile () {
}

do_install () {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/peci-hwmon-test.py ${D}/${bindir}
}

