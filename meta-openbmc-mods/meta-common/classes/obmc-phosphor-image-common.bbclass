inherit obmc-phosphor-image

IMAGE_FEATURES += " \
        obmc-bmc-state-mgmt \
        obmc-bmcweb \
        obmc-chassis-mgmt \
        obmc-chassis-state-mgmt \
        obmc-devtools \
        obmc-fan-control \
        obmc-fan-mgmt \
        obmc-flash-mgmt \
        obmc-host-ctl \
        obmc-host-ipmi \
        obmc-host-state-mgmt \
        obmc-inventory \
        obmc-leds \
        obmc-logging-mgmt \
        obmc-remote-logging-mgmt \
        obmc-net-ipmi \
        obmc-sensors \
        obmc-software \
        obmc-system-mgmt \
        obmc-user-mgmt \
        ${@bb.utils.contains('DISTRO_FEATURES', 'obmc-ubi-fs', 'read-only-rootfs', '', d)} \
        ${@bb.utils.contains('DISTRO_FEATURES', 'phosphor-mmc', 'read-only-rootfs', '', d)} \
        ssh-server-dropbear \
        obmc-debug-collector \
        obmc-network-mgmt \
        obmc-settings-mgmt \
        obmc-console \
        "

IMAGE_INSTALL:append = " \
        dbus-broker \
        entity-manager \
        fru-device \
        ipmitool \
        intel-ipmi-oem \
        phosphor-ipmi-ipmb \
        phosphor-node-manager-proxy \
        dbus-sensors \
        at-scale-debug \
        phosphor-pid-control \
        phosphor-host-postd \
        phosphor-certificate-manager \
        phosphor-sel-logger \
        smbios-mdrv2 \
        obmc-ikvm \
        system-watchdog \
        srvcfg-manager \
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
        kernel-panic-check \
        id-led-off \
        hsbp-manager \
        security-registers-check \
        nv-sync \
        security-manager \
        multi-node-nl \
        virtual-media \
        enable-nics \
        host-misc-comm-manager \
        biosconfig-manager \
        telemetry \
        i3c-tools \
        configure-usb-c \
        zip \
        peci-pcie \
        "

IMAGE_INSTALL:append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'pfr-manager', '', d)}"

IMAGE_INSTALL:append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'ncsi-monitor', '', d)}"

# this package was flagged as a security risk
IMAGE_INSTALL:remove += " lrzsz"

BAD_RECOMMENDATIONS += "phosphor-settings-manager"
