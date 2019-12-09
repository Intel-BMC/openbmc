SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "274dfe625f862e8ded2d4eb88dd856cf66bf54bf"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM_${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM_${PN} = "web; redfish "

# Enable CPU Log and Raw PECI support
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_CPU_LOG=ON"
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_RAW_PECI=ON"

# Enable Redfish BMC Journal support
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_BMC_JOURNAL=ON"

# Enable PFR support
EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DBMCWEB_ENABLE_REDFISH_PROVISIONING_FEATURE=ON', '', d)}"

#Disable the Dbus interface
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_DBUS_REST=OFF"
