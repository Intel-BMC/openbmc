FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI += " \
       file://0001-Filter-memory-thermtrip-events-based-on-DIMM-status.patch \
        "
