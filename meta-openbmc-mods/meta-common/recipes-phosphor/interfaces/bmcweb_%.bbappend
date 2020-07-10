# todo(james) remove nobranch
SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "dc3fbbd0b0021ae888a97bf48a62f30129fc3f4d"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM_${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM_${PN} = "web; redfish "

SRC_URI += "file://0001-Firmware-update-support-for-StandBySpare.patch \
            file://0002-Use-chip-id-based-UUID-for-Service-Root.patch \
            file://0003-Temporarily-disable-EventService-log-support.patch \
            file://0003-bmcweb-changes-for-setting-ApplyOptions-ClearCfg.patch \
"

# Enable PFR support
EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DBMCWEB_ENABLE_REDFISH_PROVISIONING_FEATURE=ON', '', d)}"

# Enable NBD_PROXY
EXTRA_OECMAKE += " -DBMCWEB_ENABLE_VM_NBDPROXY=ON"

# Enable Validation unsecure based on IMAGE_FEATURES
EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMCWEB_ENABLE_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"

