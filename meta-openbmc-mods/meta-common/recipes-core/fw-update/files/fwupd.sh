#!/bin/sh

log() {
    echo "$@"
}

FWTYPE=""
FWVER=""
redfish_log_fw_evt() {
    local evt=$1
    local sev=""
    local msg=""
    [ -z "$FWTYPE" ] && return
    [ -z "$FWVER" ] && return
    case "$evt" in
        start)
            evt=OpenBMC.0.1.FirmwareUpdateStarted
            msg="${FWTYPE} firmware update to version ${FWVER} started."
            sev=OK
            ;;
        success)
            evt=OpenBMC.0.1.FirmwareUpdateCompleted
            msg="${FWTYPE} firmware update to version ${FWVER} completed successfully."
            sev=OK
            ;;
        abort)
            evt=OpenBMC.0.1.FirmwareUpdateFailed
            msg="${FWTYPE} firmware update to version ${FWVER} failed."
            sev=Warning
            ;;
        *) return ;;
    esac
    logger-systemd --journald <<-EOF
		MESSAGE=$msg
		PRIORITY=2
		SEVERITY=${sev}
		REDFISH_MESSAGE_ID=${evt}
		REDFISH_MESSAGE_ARGS=${FWTYPE},${FWVER}
		EOF
}

wait_for_log_sync()
{
    sync
    sleep 5
}

PFR_BUS=4
PFR_ADDR=0x38
PFR_ID_REG=0x00
PFR_STATE_REG=0x03
PFR_PROV_REG=0x0a
PFR_INTENT_REG=0x13
pfr_read() {
    [ $# -ne 1 ] && return 1
    local reg=$1
    i2cget -y $PFR_BUS $PFR_ADDR $reg 2>/dev/null
}

pfr_write() {
    [ $# -ne 2 ] && return 1
    local reg=$1
    local val=$2
    i2cset -y $PFR_BUS $PFR_ADDR $reg $val >&/dev/null
}

pfr_active_update() {
    local factory_reset=""
    local recovery_offset=0x2a00000
    systemctl stop nv-sync.service || \
        log "BMC NV sync failed to stop"
    # transition from non-PFR to PFR image requires factory reset
    if [ ! -e /usr/share/pfr ]; then
        factory_reset="-r"
        mtd-util pfr stage $LOCAL_PATH $recovery_offset
    fi
    mtd-util $factory_reset pfr write $LOCAL_PATH
    redfish_log_fw_evt success
    # only wait for logging if not transitioning from non-PFR to PFR
    if [ -e /usr/share/pfr ]; then
        # exit bmc no nv mode
        systemctl start nv-sync.service || log "failed to start nv-sync"
        wait_for_log_sync
    fi
    reboot -f
}

pfr_staging_update() {
    log "Updating $(basename $TGT)"
    flash_erase $TGT $erase_offset $blk_cnt
    log "Writing $(stat -c "%s" "$LOCAL_PATH") bytes"
    # cat "$LOCAL_PATH" > "$TGT"
    dd bs=4k seek=$(($erase_offset / 0x1000)) if=$LOCAL_PATH of=$TGT 2>/dev/null

    # remove the updated image from /tmp
    rm -f $LOCAL_PATH
    redfish_log_fw_evt success
    log "Setting update intent in PFR CPLD"
    wait_for_log_sync

    # write to PFRCPLD about BMC update intent.
    pfr_write 0x13 $upd_intent_val
}

pfr_active_mode() {
    # check for 0xde in register file 0
    local id=$(pfr_read $PFR_ID_REG) || return 1
    [ "$id" == "0xde" ] || return 1
    local state=$(pfr_read $PFR_STATE_REG) || return 1
    local prov=$(pfr_read $PFR_PROV_REG) || return 1
    prov=$((prov & 0x20))
    [ "$prov" == "32" ] && return 0
    return 1
}

blk0blk1_update() {
    # PFR-style image update section
    # read the image type from the uploaded image
    # Byte at location 0x8 gives image type
    TGT="/dev/mtd/image-stg"
    img_type=$(hexdump -s 8 -n 1 -e '/1 "%02x\n"' $LOCAL_PATH)
    log "image-type=$img_type"

    if [ $local_file -eq 0 ]; then
        img_type_str=$(busctl get-property xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/$img_obj xyz.openbmc_project.Software.Version Purpose | cut -d " " -f 2 | cut -d "." -f 6 | sed 's/.\{1\}$//')
        img_target=$(busctl get-property xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/$img_obj xyz.openbmc_project.Software.Activation RequestedActivation | cut -d " " -f 2| cut -d "." -f 6 | sed 's/.\{1\}$//')
    else
        img_type_str='BMC'
        img_target='Active'
    fi

    apply_time=$(busctl get-property xyz.openbmc_project.Settings /xyz/openbmc_project/software/apply_time xyz.openbmc_project.Software.ApplyTime RequestedApplyTime | cut -d " " -f 2 | cut -d "." -f 6 | sed 's/.\{1\}$//')
    log "image-name=$img_type_str"
    log "image-target=$img_target"
    log "apply_time=$apply_time"

    case "$img_type" in
    04)
        if [ "$img_type_str" == 'BMC' ]; then
            # BMC image - max size 32MB
            log "BMC firmware image"
            img_size=33554432
            if [ "$img_target" == 'StandbySpare' ]; then
                upd_intent_val=0x10
            else
                upd_intent_val=0x08
            fi
            erase_offset=0
            FWTYPE="BMC"
            FWVER="${RANDOM}-fixme"
        else
            # log error the image selected for update is not same as downloaded.
            log "Mismatch: image selected for update and image parsed are different"
            redfish_log_fw_evt abort
            return 1
        fi
        ;;
    00)
        if [ "$img_type_str" == 'Other' ]; then
            log "CPLD firmware image"
            # CPLD image- max size 1MB
            img_size=1048576
            if [ "$img_target" == 'StandbySpare' ]; then
                upd_intent_val=0x20
            else
                upd_intent_val=0x04
            fi
            erase_offset=0x3000000
            FWTYPE="CPLD"
            FWVER="${RANDOM}-fixme"
        else
            # log error the image selected for update is not same as downloaded.
            log "Mismatch: image selected for update and image parsed are different"
            redfish_log_fw_evt abort
            return 1
        fi
        ;;
    02)
        if [ "$img_type_str" = 'Host' ]; then
            # BIOS image- max size 16MB
            log "BIOS firmware image"
            img_size=16777216
            if [ "$img_target" == 'StandbySpare' ]; then
                upd_intent_val=0x02
            else
                upd_intent_val=0x41
            fi
            erase_offset=0x2000000
            # TODO: parse out the fwtype and fwver once that is specified
            FWTYPE="BIOS"
            FWVER="${RANDOM}-fixme"
        else
            # log error the image selected for update is not same as downloaded.
            log "Mismatch: image selected for update and image parsed are different"
            redfish_log_fw_evt abort
            return 1
        fi
        ;;
    *)
        log "Unknown image type ${img_type}"
        return 1
        ;;
    esac

    # For deferred updates
    if [ "$apply_time" == 'OnReset' ]; then
        upd_intent_val=$(( "$upd_intent_val"|0x80 ))
    fi

    # do a quick sanity check on the image
    if [ $(stat -c "%s" "$LOCAL_PATH") -gt $img_size ]; then
        log "Update file "$LOCAL_PATH" is bigger than the supported image size"
        redfish_log_fw_evt abort
        return 1
    fi
    blk_cnt=$((img_size / 0x10000))

    if pfr_active_mode; then
        # pfr enforcing mode; any b0b1 image type
        pfr_staging_update
    elif [ "$img_type" == '04' ]; then
        # legacy mode; pfr is not present but we got a pfr image
        log "Updating BMC active firmware- PFR unprovisioned mode"
        pfr_active_update
    else
        # error; pfr is not present but we got a pfr image,
        # an invalid image, or nonBMC image
        log "PFR inactive or invalid image type:${img_type}, cowardly refusing to process image"
        redfish_log_fw_evt abort
        return 1
    fi
}

ping_pong_update() {
    # if some one tries to update with non-PFR on PFR image
    # just exit
    if [ -e /usr/share/pfr ]; then
        log "Update exited as non-PFR image is tried onto PFR image"
        redfish_log_fw_evt abort
        return 1
    fi
    # do a quick sanity check on the image
    if [ $(stat -c "%s" "$LOCAL_PATH") -lt 10000000 ]; then
        log "Update file "$LOCAL_PATH" seems to be too small"
        redfish_log_fw_evt abort
        return 1
    fi
    dtc -I dtb -O dtb "$LOCAL_PATH" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log "Update file $LOCAL_PATH doesn't seem to be in the proper format"
        redfish_log_fw_evt abort
        return 1
    fi

    # guess based on fw_env which partition we booted from
    local BOOTADDR=$(fw_printenv bootcmd | awk '{print $2}')
    local TGT="/dev/mtd/image-a"
    case "$BOOTADDR" in
        20080000) TGT="/dev/mtd/image-b"; BOOTADDR="22480000" ;;
        22480000) TGT="/dev/mtd/image-a"; BOOTADDR="20080000" ;;
        *)        TGT="/dev/mtd/image-a"; BOOTADDR="20080000" ;;
    esac
    log "Updating $(basename $TGT) (use bootm $BOOTADDR)"
    flash_erase $TGT 0 0
    log "Writing $(stat -c "%s" "$LOCAL_PATH") bytes"
    cat "$LOCAL_PATH" > "$TGT"
    fw_setenv "bootcmd" "bootm ${BOOTADDR}"
    redfish_log_fw_evt success
    wait_for_log_sync
    # reboot
    reboot -f
}

fetch_fw() {
    PROTO=$(echo "$URI" | sed 's,\([a-z]*\)://.*$,\1,')
    REMOTE=$(echo "$URI" | sed 's,.*://\(.*\)$,\1,')
    REMOTE_HOST=$(echo "$REMOTE" | sed 's,\([^/]*\)/.*$,\1,')
    if [ "$PROTO" = 'scp' ]; then
        REMOTE_PATH=$(echo "$REMOTE" | cut -d':' -f2)
    else
        REMOTE_PATH=$(echo "$REMOTE" | sed 's,[^/]*/\(.*\)$,\1,')
    fi
    LOCAL_PATH="/tmp/$(basename $REMOTE_PATH)"
    log "PROTO=$PROTO"
    log "REMOTE=$REMOTE"
    log "REMOTE_HOST=$REMOTE_HOST"
    log "REMOTE_PATH=$REMOTE_PATH"
    if [ ! -e $LOCAL_PATH ] || [ $(stat -c %s $LOCAL_PATH) -eq 0 ]; then
        log "Download '$REMOTE_PATH' from $PROTO $REMOTE_HOST $REMOTE_PATH"
        case "$PROTO" in
            scp)
                mkdir -p $HOME/.ssh
                if [ -e "$SSH_ID" ]; then
                    ARG_ID="-i $SSH_ID"
                fi
                scp $ARG_ID $REMOTE_HOST$REMOTE_PATH $LOCAL_PATH
                if [ $? -ne 0 ]; then
                    log "scp $REMOTE $LOCAL_PATH failed!"
                    return 1
                fi
                ;;
            tftp)
                cd /tmp
                tftp -g -r "$REMOTE_PATH" "$REMOTE_HOST"
                if [ $? -ne 0 ]; then
                    log "tftp -g -r \"$REMOTE_PATH\" \"$REMOTE_HOST\" failed!"
                    return 1
                fi
                ;;
            http|https|ftp)
                wget --no-check-certificate "$URI" -O "$LOCAL_PATH"
                if [ $? -ne 0 ]; then
                    log "wget $URI failed!"
                    return 1
                fi
                ;;
            file)
                LOCAL_PATH=$(echo $URI | sed 's,^file://,,')
                ;;
            *)
                log "Invalid URI $URI"
                return 1
                ;;
        esac
    fi
}

update_fw() {
    redfish_log_fw_evt start
    # determine firmware file type
    local magic=$(hexdump -n 4 -v -e '/1 "%02x"' "$LOCAL_PATH")
    case "$magic" in
        d00dfeed) ping_pong_update ;;
        19fdeab6) blk0blk1_update ;;
        *) log "Uknown file type ${magic}"
    esac
}

# if this script was sourced, just return without executing anything
[ "$_" != "$0" ] && return 0 >&/dev/null

usage() {
        echo "usage: $(basename $0) uri"
        echo "       uri is something like: file:///path/to/fw"
        echo "                              tftp://tftp.server.ip.addr/path/to/fw"
        echo "                              scp://[user@]scp.server.ip.addr:/path/to/fw"
        echo "                              http[s]://web.server.ip.addr/path/to/fw"
        echo "                              ftp://[user@]ftp.server.ip.addr/path/to/fw"
        exit 1
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then usage; fi
if [ $# -eq 0 ]; then
    # set DEFURI in $HOME/.fwupd.defaults
    URI="$DEFURI"
else
    if [[ "$1" == *"/"* ]]; then
        URI=$1 # local file
        local_file=1 ;
    else
        URI="file:////tmp/images/$1/image-runtime"
        img_obj=$1
        local_file=0 ;
    fi
fi
fetch_fw && update_fw
