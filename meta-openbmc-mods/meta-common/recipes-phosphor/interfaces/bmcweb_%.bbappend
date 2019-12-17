SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "97d57aaa0b95a110c71016d190f95f853051126a"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM_${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM_${PN} = "web; redfish "

SRC_URI += "file://0001-Firmware-update-support-for-StandBySpare.patch \
            "

# Enable CPU Log and Raw PECI support
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_CPU_LOG=ON"
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_RAW_PECI=ON"

# Enable Redfish BMC Journal support
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_BMC_JOURNAL=ON"

# Enable PFR support
EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DBMCWEB_ENABLE_REDFISH_PROVISIONING_FEATURE=ON', '', d)}"

#Disable the Dbus interface
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_DBUS_REST=OFF"
