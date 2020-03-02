
# Disable the shell to remove the usage of readline lib
# to fix the license conflict issue. More information:
# https://lists.ozlabs.org/pipermail/openbmc/2019-November/019678.html

EXTRA_OECONF_append = " --disable-ipmishell"
