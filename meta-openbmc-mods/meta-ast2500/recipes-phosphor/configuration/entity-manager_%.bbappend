FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"
SRC_URI_append = " file://0001-Blacklist-DIMM-Bus.patch \
                   file://WC-Baseboard.json \
                   file://WP-Baseboard.json \
                   file://TNP-baseboard.json \
                   file://FCXXPDBASSMBL_PDB.json \
                   file://OPB2RH-Chassis.json \
                   file://CYP-baseboard.json \
                   file://J85894-HSBP.json \
                   file://CPC-Baseboard.json \
                   file://MIDPLANE-2U2X12SWITCH.json \
                   file://WC-Chassis.json \
                   file://blocklist.json"

RDEPENDS_${PN} += " default-fru"

do_install_append() {
     install -d ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/WC-Baseboard.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/WP-Baseboard.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/TNP-baseboard.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/FCXXPDBASSMBL_PDB.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/OPB2RH-Chassis.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/CYP-baseboard.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/J85894-HSBP.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/CPC-Baseboard.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/MIDPLANE-2U2X12SWITCH.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/WC-Chassis.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/blocklist.json ${D}/usr/share/entity-manager
}
