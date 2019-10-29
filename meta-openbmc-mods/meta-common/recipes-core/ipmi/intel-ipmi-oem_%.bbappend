EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DINTEL_PFR_ENABLED=ON', '', d)}"
SRC_URI = "git://github.com/openbmc/intel-ipmi-oem.git"
SRCREV = "262276f4964191d780aeab3a821de54b01c0a8ff"
