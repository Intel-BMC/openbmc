EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DINTEL_PFR_ENABLED=ON', '', d)}"
EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMC_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"
SRC_URI = "git://github.com/openbmc/intel-ipmi-oem.git"
SRCREV = "38b58f5866602906833f7afc864dd2729516dd7f"
