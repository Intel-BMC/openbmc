SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "12c7f4388b58a974265827ab62d3981ba98ed8f2"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM_${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM_${PN} = "web; redfish "

SRC_URI += "file://0001-Firmware-update-support-for-StandBySpare.patch \
            file://0002-Match-BMCWeb-crashdump-to-the-D-Bus-interface-provid.patch \
"

# Enable PFR support
EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DBMCWEB_ENABLE_REDFISH_PROVISIONING_FEATURE=ON', '', d)}"

# Enable NBD_PROXY
EXTRA_OECMAKE += " -DBMCWEB_ENABLE_VM_NBDPROXY=ON"

# Enable Validation unsecure based on IMAGE_FEATURES
EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMCWEB_ENABLE_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"

