FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
           file://0001-sdbusplus-settable-timeout-value-for-async_method_ca.patch \
           file://0002-sdbusplus_Add_new_signal_and_extend_set_property_methods.patch \
           "
