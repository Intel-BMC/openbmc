add_watchdog_confs() {

    interval=10 # minutes
    count=5 # allowed reboots

    for service in $(ls $D/lib/systemd/system | grep -o ".*service"); do
        if [[ $service == *"mapper-wait"* ]]; then
            continue
        fi

        if cat $D/lib/systemd/system/${service} | grep oneshot > /dev/null; then
            continue
        fi

        folder="$D/etc/systemd/system/${service}.d"
        mkdir -p "${folder}"
        fname="${folder}/watchdog.conf"
        echo "[Unit]" > ${fname}
        echo "OnFailure=watchdog-reset.service" >> ${fname}
        echo "[Service]" >> "${fname}"
        echo "StartLimitInterval=${interval}min" >> "${fname}"
        echo "StartLimitBurst=${count}" >> "${fname}"
     done

}

ROOTFS_POSTINSTALL_COMMAND += "add_watchdog_confs"
