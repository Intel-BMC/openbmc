FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"
SRC_URI_append = " file://0001-Blacklist-DIMM-Bus.patch \
                   file://WC-Baseboard.json \
                   file://WP-Baseboard.json \
                   file://TNP-baseboard.json \
                   file://BC-Baseboard.json \
                   file://MC-Baseboard.json \
                   file://FCXXPDBASSMBL_PDB.json \
                   file://OPB2RH-Chassis.json \
                   file://CYP-baseboard.json \
                   file://J85894-HSBP.json \
                   file://CPC-Baseboard.json \
                   file://MIDPLANE-2U2X12SWITCH.json \
                   file://WC-Chassis.json"

RDEPENDS_${PN} += " default-fru"

do_install_append() {
     install -d ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/*.json ${D}/usr/share/entity-manager/configurations
}
