FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI += "file://0001-Customize-phosphor-watchdog-for-Intel-platforms.patch \
           "

# Remove the override to keep service running after DC cycle
SYSTEMD_OVERRIDE_${PN}:remove = "poweron.conf:phosphor-watchdog@poweron.service.d/poweron.conf"
SYSTEMD_SERVICE:${PN} = "phosphor-watchdog.service"
