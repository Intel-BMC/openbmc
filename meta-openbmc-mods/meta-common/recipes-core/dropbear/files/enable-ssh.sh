#!/bin/sh

if [ -e /etc/systemd/system/dropbear@.service ] && \
   [ -e /etc/systemd/system/sockets.target.wants/dropbear.socket ]
then
    echo "SSH is already enabled"
else
    cp /usr/share/misc/dropbear@.service /etc/systemd/system/dropbear@.service
    cp /usr/share/misc/dropbear.socket /etc/systemd/system/dropbear.socket
    ln -s  /etc/systemd/system/dropbear.socket /etc/systemd/system/sockets.target.wants/dropbear.socket
    groupmems -g priv-admin -a root
    systemctl daemon-reload
    systemctl restart dropbear.socket
    echo "Enabled SSH service for root user successful"
fi
