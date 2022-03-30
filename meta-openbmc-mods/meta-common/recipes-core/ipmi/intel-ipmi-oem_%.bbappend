EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DINTEL_PFR_ENABLED=ON', '', d)}"
EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMC_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"
EXTRA_OECMAKE += "-DUSING_ENTITY_MANAGER_DECORATORS=OFF"
SRC_URI = "git://github.com/openbmc/intel-ipmi-oem.git"
SRCREV = "d2d60ab5b325c4630c8e794e861b88cf3c9337bf"

FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

