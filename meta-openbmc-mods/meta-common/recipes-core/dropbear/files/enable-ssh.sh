#!/bin/sh

usage="$(basename $0) [-h] [-d] -- Enable/Disable ssh for root user
where:
    -h  help
    -d  disable ssh and remove priv-admin permission for root user"

enable_ssh() {
    systemctl enable --now dropbear.socket
    groupmems -g priv-admin -a root
    echo "Enabled SSH service for root user successful"
}

disable_ssh() {
    systemctl disable --now dropbear.socket
    systemctl stop dropbear@*.service
    groupmems -g priv-admin -d root
    echo "Disabled SSH service"
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
