#!/bin/sh

SSH_ID=$HOME/.ssh/id_rsa.db
[ -e $HOME/.fwupd.defaults ] && source $HOME/.fwupd.defaults

usage() {
        echo "usage: $(basename $0) uri"
        echo "       uri is something like: file:///path/to/fw"
        echo "                              tftp://tftp.server.ip.addr/path/to/fw"
        echo "                              scp://[user@]scp.server.ip.addr:/path/to/fw"
        echo "                              http[s]://web.server.ip.addr/path/to/fw"
        echo "                              ftp://[user@]ftp.server.ip.addr/path/to/fw"
        exit 1
}

logevent_update_started() {
echo
cat <<EOF | logger-systemd --journald
REDFISH_MESSAGE_ID=OpenBMC.0.1.FirmwareUpdateStarted
PRIORITY=2
MESSAGE=$1 firmware update to version $2 started.
REDFISH_MESSAGE_ARGS=$1,$2
EOF
}

logevent_update_completed() {
echo
cat <<EOF | logger-systemd --journald
REDFISH_MESSAGE_ID=OpenBMC.0.1.FirmwareUpdateCompleted
PRIORITY=2
MESSAGE=$1 firmware update to version $2 completed.
REDFISH_MESSAGE_ARGS=$1,$2
EOF
}

logevent_update_failed() {
echo
cat <<EOF | logger-systemd --journald
REDFISH_MESSAGE_ID=OpenBMC.0.1.FirmwareUpdateFailed
PRIORITY=4
MESSAGE=$1 firmware update to version $2 failed.
REDFISH_MESSAGE_ARGS=$1,$2
EOF
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then usage; fi
if [ $# -eq 0 ]; then
	# set DEFURI in $HOME/.fwupd.defaults
    URI="$DEFURI"
else
    URI="$1"
fi

PROTO=$(echo "$URI" | sed 's,\([a-z]*\)://.*$,\1,')
REMOTE=$(echo "$URI" | sed 's,.*://\(.*\)$,\1,')
REMOTE_HOST=$(echo "$REMOTE" | sed 's,\([^/]*\)/.*$,\1,')
if [ "$PROTO" = 'scp' ]; then
    REMOTE_PATH=$(echo "$REMOTE" | cut -d':' -f2)
else
    REMOTE_PATH=$(echo "$REMOTE" | sed 's,[^/]*/\(.*\)$,\1,')
fi
LOCAL_PATH="/tmp/$(basename $REMOTE_PATH)"
echo "PROTO=$PROTO"
echo "REMOTE=$REMOTE"
echo "REMOTE_HOST=$REMOTE_HOST"
echo "REMOTE_PATH=$REMOTE_PATH"
if [ ! -e $LOCAL_PATH ] || [ $(stat -c %s $LOCAL_PATH) -eq 0 ]; then
    echo "Download '$REMOTE_PATH' from $PROTO $REMOTE_HOST $REMOTE_PATH"
    case "$PROTO" in
        scp)
            mkdir -p $HOME/.ssh
            if [ -e "$SSH_ID" ]; then
                ARG_ID="-i $SSH_ID"
            fi
            scp $ARG_ID $REMOTE_HOST$REMOTE_PATH $LOCAL_PATH
            if [ $? -ne 0 ]; then
                echo "scp $REMOTE $LOCAL_PATH failed!"
                exit 255
            fi
            ;;
        tftp)
            cd /tmp
            tftp -g -r "$REMOTE_PATH" "$REMOTE_HOST"
            if [ $? -ne 0 ]; then
                echo "tftp -g -r \"$REMOTE_PATH\" \"$REMOTE_HOST\" failed!"
                exit 255
            fi
            ;;
        http|https|ftp)
            wget --no-check-certificate "$URI" -O "$LOCAL_PATH"
            if [ $? -ne 0 ]; then
                echo "wget $URI failed!"
                exit 255
            fi
            ;;
        file)
            cp "$REMOTE_PATH" "$LOCAL_PATH"
            ;;
        *)
            echo "Invalid URI $URI"
            exit 1;
            ;;
    esac
fi

# PFR image update section
# this file being created at build time for PFR images
if [ -e /usr/share/pfr ]
then
# read the image type from the uploaded image
# Byte at location 0x8 gives image type
img_type=$(hexdump -s 8 -n 1 $LOCAL_PATH | cut -b12,1 | sed '2d;')
echo "image-type=$img_type"

# BMC image - max size 32MB
if [ "$img_type" = '04' ]; then
    echo "BMC firmware image"
    # 32MB - 33554432
    img_size=33554432
    upd_intent_val=0x08
    # page is at 4KB boundary
    img_page_offset=0
    erase_offset=0
    blk_cnt=0x200
# CPLD image- max size 4MB
elif [ "$img_type" = '00' ]; then
    echo "CPLD firmware image"
    # 4MB - 4194304
    img_size=4194304
    upd_intent_val=0x04
    # dd command accepts the offset in decimal
    # below is the page offset in 4KB boundary
    img_page_offset=12288
    erase_offset=0x3000000
    blk_cnt=0x40
# BIOS image- max size 16MB
elif [ "$img_type" = '02' ]; then
    echo "BIOS firmware image"
    # 16MB- 16777216
    img_size=16777216
    upd_intent_val=0x01
    # dd command accepts the offset in decimal
    # below is the page offset in 4KB boundary
    img_page_offset=8192
    erase_offset=0x2000000
    blk_cnt=0x100
else
    echo "${img_type}:Unknown image type, exiting the firmware update script"
    exit 1
fi

# do a quick sanity check on the image
if [ $(stat -c "%s" "$LOCAL_PATH") -gt $img_size ]; then
    echo "Update file "$LOCAL_PATH" is bigger than the supported image size"
    exit 1
fi

TGT="/dev/mtd/image-stg"
echo "Updating $(basename $TGT)"
flash_erase $TGT $erase_offset $blk_cnt
echo "Writing $(stat -c "%s" "$LOCAL_PATH") bytes"
# cat "$LOCAL_PATH" > "$TGT"
dd bs=4k seek=$img_page_offset if=$LOCAL_PATH of=$TGT
sync
echo "Written $(stat -c "%s" "$LOCAL_PATH") bytes"
# remove the updated image from /tmp
rm -f $LOCAL_PATH
echo "Setting update intent in PFR CPLD"
sleep 5 # delay for sync and to get the above echo messages
# write to PFRCPLD about BMC update intent.
i2cset -y 4 0x38 0x13 $upd_intent_val

else # Non-PFR image update section
version="unknown"
component="BMC"
manifest_file=$(dirname "${REMOTE_PATH}")"/MANIFEST"
if [ -e $manifest_file ]; then
    version=`awk -F= -v key="version" '$1==key {print $2}' $manifest_file`
fi

logevent_update_started $component $version

# do a quick sanity check on the image
if [ $(stat -c "%s" "$LOCAL_PATH") -lt 10000000 ]; then
    echo "Update file "$LOCAL_PATH" seems to be too small"
    logevent_update_failed $component $version
    exit 1
fi
dtc -I dtb -O dtb "$LOCAL_PATH" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Update file $LOCAL_PATH doesn't seem to be in the proper format"
    logevent_update_failed $component $version
    exit 1
fi

# guess based on fw_env which partition we booted from
BOOTADDR=$(fw_printenv bootcmd | awk '{print $2}')

TGT="/dev/mtd/image-a"
case "$BOOTADDR" in
	20080000) TGT="/dev/mtd/image-b"; BOOTADDR="22480000" ;;
	22480000) TGT="/dev/mtd/image-a"; BOOTADDR="20080000" ;;
	*)        TGT="/dev/mtd/image-a"; BOOTADDR="20080000" ;;
esac
echo "Updating $(basename $TGT) (use bootm $BOOTADDR)"
flash_erase $TGT 0 0
if [ $? -ne 0 ]; then
    echo "Erasing the flash failed"
    logevent_update_failed $component $version
    exit 1
fi
echo "Writing $(stat -c "%s" "$LOCAL_PATH") bytes"
cat "$LOCAL_PATH" > "$TGT"
if [ $? -ne 0 ]; then
    echo "Writing to flash failed"
    logevent_update_failed $component $version
    exit 1
fi
fw_setenv "bootcmd" "bootm ${BOOTADDR}"

logevent_update_completed $component $version

# reboot
reboot
fi
