# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM_${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM_${PN} = "web; redfish "

FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI += "file://0001-Refine-KVM-websock-proxy.patch"

# Enable CPU Log and Raw PECI support
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_CPU_LOG=ON"
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_RAW_PECI=ON"

# Enable Redfish BMC Journal support
EXTRA_OECMAKE += "-DBMCWEB_ENABLE_REDFISH_BMC_JOURNAL=ON"
