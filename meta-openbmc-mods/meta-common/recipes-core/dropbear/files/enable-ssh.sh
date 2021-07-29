#!/bin/sh

usage="$(basename "$0") [-h] [-d] -- Enable/Disable ssh for root user
where:
    -h  help
    -d  disable ssh and remove priv-admin permission for root user"

enable_ssh() {
    if [ -e /etc/systemd/system/dropbear@.service ] &&
        [ -e /etc/systemd/system/sockets.target.wants/dropbear.socket ]; then
        echo "SSH is already enabled"
    else
        cp /usr/share/misc/dropbear@.service /etc/systemd/system/dropbear@.service
        cp /usr/share/misc/dropbear.socket /etc/systemd/system/dropbear.socket
        ln -s /etc/systemd/system/dropbear.socket /etc/systemd/system/sockets.target.wants/dropbear.socket
        groupmems -g priv-admin -a root
        systemctl daemon-reload
        systemctl restart dropbear.socket
        echo "Enabled SSH service for root user successful"
    fi
}

disable_ssh() {
    if [ -e /etc/systemd/system/dropbear@.service ] &&
        [ -e /etc/systemd/system/sockets.target.wants/dropbear.socket ]; then
        systemctl stop dropbear.socket
        systemctl stop dropbear@*.service
        rm -rf /etc/systemd/system/sockets.target.wants/dropbear.socket
        rm -rf /etc/systemd/system/dropbear.socket
        rm -rf /etc/systemd/system/dropbear@.service
        groupmems -g priv-admin -d root
        echo "SSH disabled"
    else
        echo "SSH is already disabled"
    fi
}

case "$1" in
"-h")
    echo ${usage}
    ;;
"-d")
    disable_ssh
    ;;
*)
    enable_ssh
    ;;
esac
