EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DINTEL_PFR_ENABLED=ON', '', d)}"
EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMC_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"
EXTRA_OECMAKE += "-DUSING_ENTITY_MANAGER_DECORATORS=OFF"
SRC_URI = "git://github.com/openbmc/intel-ipmi-oem.git"
SRCREV = "e83c70aab0479a8103638166b330a06e499f4449"

FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

