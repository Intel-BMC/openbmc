FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"
SRC_URI_append = " file://WC-Baseboard.json \
                   file://WP-Baseboard.json \
                   file://TNP-baseboard.json \
                   file://FCXXPDBASSMBL_PDB.json \
                   file://OPB2RH-Chassis.json"

RDEPENDS_${PN} += " default-fru"

do_install_append(){
     install -d ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/*.json ${D}/usr/share/entity-manager/configurations
}
