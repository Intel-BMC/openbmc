FILES_${PN} += "/usr/lib/libboost_chrono.so* \
               /usr/lib/libboost_context.so* \
               /usr/lib/libboost_thread.so*"

BOOST_LIBS_intel += "iostreams coroutine"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
