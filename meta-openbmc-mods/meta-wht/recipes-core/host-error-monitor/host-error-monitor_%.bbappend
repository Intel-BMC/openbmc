FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI += " \
       file://0001-Filter-memory-thermtrip-events-based-on-DIMM-status.patch \
       file://0002-Add-a-workaround-for-spurious-CPU-errors.patch \
       file://0003-Override-crashdump-timeout-to-30-minutes.patch \
        "
