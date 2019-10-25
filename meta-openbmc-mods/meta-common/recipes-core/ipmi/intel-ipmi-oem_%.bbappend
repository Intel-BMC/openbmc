EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DINTEL_PFR_ENABLED=ON', '', d)}"
SRC_URI = "git://github.com/openbmc/intel-ipmi-oem.git"
SRCREV = "ca99ef5912b9296e09c8f9cb246ce291f9970750"
