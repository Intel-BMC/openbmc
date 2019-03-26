inherit obmc-phosphor-image

IMAGE_INSTALL_append = " \
        fan-default-speed \
        bmcweb \
        dbus-broker \
        dtc \
        dtoverlay \
        entity-manager \
        ipmitool \
        ipmi-providers \
        intel-ipmi-oem \
        phosphor-ipmi-ipmb \
        phosphor-node-manager-proxy \
        dbus-sensors \
        phosphor-webui \
        rest-dbus-static \
        phosphor-pid-control \
        phosphor-host-postd \
        smbios-mdrv1 \
        phosphor-certificate-manager \
        set-passthrough \
        phosphor-sel-logger \
        gpiodaemon \
        smbios-mdrv2 \
        obmc-ikvm \
        system-watchdog \
        frb2-watchdog \
        srvcfg-manager \
        callback-manager \
        post-code-manager \
        preinit-mounts \
        mtd-utils-ubifs \
        "

# this package was flagged as a security risk
IMAGE_INSTALL_remove += " lrzsz"

