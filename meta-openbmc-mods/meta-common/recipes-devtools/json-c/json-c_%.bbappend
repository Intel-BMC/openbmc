FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI +=  "file://0001-Protect-array_list_del_idx-against-size_t-overflow.patch \
             file://0002-Prevent-division-by-zero-in-linkhash.patch \
             file://0003-Fix-integer-overflows.patch \
            "
