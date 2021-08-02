FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0035-Fix-build-error.patch \
    file://0036-sunrpc-use-snprintf-to-guard-against-buffer-overflow.patch \
    file://0036-Use-__pthread_attr_copy-in-mq_notify-bug-27896.patch \
    file://0037-Fix-use-of-__pthread_attr_copy-in-mq_notify-bug-27896.patch \
    "
