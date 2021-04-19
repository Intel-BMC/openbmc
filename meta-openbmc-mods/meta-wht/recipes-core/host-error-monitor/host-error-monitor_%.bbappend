FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Configure-host-error-monitors-for-meta-wht.patch \
    file://0002-Filter-memory-thermtrip-events-based-on-DIMM-status.patch \
    "
