FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI += "file://0001-Add-redfish-log-support-for-IPMI-watchdog-timeout-ac.patch \
            file://0002-Add-restart-cause-support.patch \
            file://0003-Add-redfish-log-support-for-IPMI-watchdog-pre-timeou.patch \
           "

# Remove the override to keep service running after DC cycle
SYSTEMD_OVERRIDE_${PN}_remove = "poweron.conf:phosphor-watchdog@poweron.service.d/poweron.conf"
