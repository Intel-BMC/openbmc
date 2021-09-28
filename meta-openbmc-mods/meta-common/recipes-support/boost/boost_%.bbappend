FILES:${PN} += "/usr/lib/libboost_chrono.so* \
               /usr/lib/libboost_atomic.so* \
               /usr/lib/libboost_context.so* \
               /usr/lib/libboost_thread.so*"

BOOST_LIBS:intel += "iostreams coroutine filesystem program_options regex system"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
