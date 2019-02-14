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

# do a quick sanity check on the image
if [ $(stat -c "%s" "$LOCAL_PATH") -lt 10000000 ]; then
    echo "Update file "$LOCAL_PATH" seems to be too small"
    exit 1
fi
dtc -I dtb -O dtb "$LOCAL_PATH" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Update file $LOCAL_PATH doesn't seem to be in the proper format"
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
echo "Writing $(stat -c "%s" "$LOCAL_PATH") bytes"
cat "$LOCAL_PATH" > "$TGT"
fw_setenv "bootcmd" "bootm ${BOOTADDR}"

# reboot
reboot

