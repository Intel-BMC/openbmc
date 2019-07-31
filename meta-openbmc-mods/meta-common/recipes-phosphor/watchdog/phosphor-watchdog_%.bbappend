FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRCREV = "c35135d32f9cb84b62de7b72eee3a2e87b4b3d4d"
SRC_URI += "file://0001-Move-Phosphor-Watchdog-to-Not-Use-Service-Files.patch \
            file://0002-Stop-the-watchdog-when-the-host-is-going-to-off.patch \
           "

# Remove the override to keep service running after DC cycle
SYSTEMD_OVERRIDE_${PN}_remove = "poweron.conf:phosphor-watchdog@poweron.service.d/poweron.conf"
SYSTEMD_SERVICE_${PN} = "phosphor-watchdog.service"
