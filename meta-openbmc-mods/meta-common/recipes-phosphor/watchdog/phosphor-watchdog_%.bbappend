FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRCREV = "c35135d32f9cb84b62de7b72eee3a2e87b4b3d4d"
SRC_URI += "file://0001-Customize-phosphor-watchdog-for-Intel-platforms.patch \
           "

# Remove the override to keep service running after DC cycle
SYSTEMD_OVERRIDE_${PN}_remove = "poweron.conf:phosphor-watchdog@poweron.service.d/poweron.conf"
SYSTEMD_SERVICE_${PN} = "phosphor-watchdog.service"
