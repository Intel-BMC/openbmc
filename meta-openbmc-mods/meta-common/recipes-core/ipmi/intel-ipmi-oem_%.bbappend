EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DINTEL_PFR_ENABLED=ON', '', d)}"
EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMC_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"
EXTRA_OECMAKE += "-DUSING_ENTITY_MANAGER_DECORATORS=OFF"
SRC_URI = "git://github.com/openbmc/intel-ipmi-oem.git"
SRCREV = "04a38ed10db3a0203aa7804bfea6fbd69dafdde8"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

SRC_URI += "file://0001-Fix-cold-redundancy-is-not-runing-as-user-configurat.patch \
            file://0002-GetFwVersionInfo-Fix-for-Firmware-aux-version.patch \
            file://0003-storagecommands-Fix-for-GetFruAreaInfo-command.patch \
            file://0004-firmware-update-Add-Support-to-get-fwSecurityVer.patch \
            file://0005-oemcommands-Fix-for-set-security-mode-to-mfg-mode.patch \
            file://0006-Update-Product-ID-for-EEPROM-FRU-platforms.patch \
            file://0007-ipmi-whitelist-Allow-set-securitymode-cmd-from-KCS.patch \
            file://0008-Add-sufficient-delay-to-create-smbios2-file.patch \
           "
