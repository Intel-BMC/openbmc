inherit obmc-phosphor-image

IMAGE_INSTALL_append = " \
        bmcweb \
        dbus-broker \
        entity-manager \
        ipmitool \
        intel-ipmi-oem \
        phosphor-ipmi-ipmb \
        phosphor-node-manager-proxy \
        dbus-sensors \
        phosphor-webui \
        at-scale-debug \
        phosphor-pid-control \
        phosphor-host-postd \
        phosphor-certificate-manager \
        phosphor-sel-logger \
        smbios-mdrv2 \
        obmc-ikvm \
        system-watchdog \
        frb2-watchdog \
        service-config-manager \
        callback-manager \
        phosphor-post-code-manager \
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
        id-led-off \
        hsbp-manager \
        security-registers-check \
        pch-time-sync \
        nv-sync \
        security-manager \
        multi-node-nl \
        virtual-media \
        enable-nics \
        host-misc-comm-manager \
        dhcp-check \
        "

IMAGE_INSTALL_append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'pfr-manager', '', d)}"

IMAGE_INSTALL_append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'ncsi-monitor', '', d)}"

# this package was flagged as a security risk
IMAGE_INSTALL_remove += " lrzsz"

BAD_RECOMMENDATIONS += "phosphor-settings-manager"
