inherit obmc-phosphor-image
inherit systemd-watchdog

IMAGE_INSTALL_append = " \
        bmcweb \
        dbus-broker \
        dtc \
        entity-manager \
        ipmitool \
        intel-ipmi-oem \
        phosphor-ipmi-ipmb \
        phosphor-node-manager-proxy \
        dbus-sensors \
        phosphor-webui \
        rest-dbus-static \
        phosphor-pid-control \
        phosphor-host-postd \
        phosphor-certificate-manager \
        phosphor-sel-logger \
        smbios-mdrv1 \
        smbios-mdrv2 \
        obmc-ikvm \
        system-watchdog \
        frb2-watchdog \
        srvcfg-manager \
        callback-manager \
        post-code-manager \
        preinit-mounts \
        mtd-utils-ubifs \
        special-mode-mgr \
        rsyslog \
        static-mac-addr \
        phosphor-u-boot-mgr \
        prov-mode-mgr \
        ac-boot-check \
        host-error-monitor \
        beepcode-mgr \
        psu-manager \
        kernel-panic-check \
        "

IMAGE_INSTALL_append = "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'intel-pfr-manager', '', d)}"

# this package was flagged as a security risk
IMAGE_INSTALL_remove += " lrzsz"

