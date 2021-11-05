SYSTEMD_AUTO_ENABLE:${PN} = "disable"
EXTRA_OECONF += " --disable-notify_email --disable-notify_nagios --disable-apache --disable-apcups --disable-battery --disable-bind --disable-email --disable-hddtemp --disable-nginx --disable-infiniband --disable-openvpn --disable-zfs_arc --disable-teamspeak2"
