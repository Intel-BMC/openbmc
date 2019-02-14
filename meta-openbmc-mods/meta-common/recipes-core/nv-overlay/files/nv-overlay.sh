#!/bin/sh

# Copyright 2017 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# provide a couple of places in the RO root filesystem
# that can be made RW with an overlayfs

# start with /proc and /tmp mounted
[ -e /proc/mounts ] || mount -t proc proc /proc
grep -q /tmp /proc/mounts || mount -t tmpfs -o rw,nosuid,nodev tmp /tmp

# list of things that need to be rw at boot
NV_OVERLAYS="/etc /var /home"
TMP_FS="/var/log /var/lib/systemd/coredump /media"

# place to mount the real jffs2 backing store
RWFS_MNT=/tmp/.rwfs

if grep -q "$RWFS_MNT" /proc/mounts; then
    # quit - we have already run
    exit 0
fi
mkdir -p "$RWFS_MNT"

mtd_by_name() {
    local name="$1"
    local mtd="/dev/$(grep "$name" /proc/mtd | cut -d : -f 1)"
    echo "$mtd"
}

mtdblock_by_name() {
    local name="$1"
    local mtdblock="$(mtd_by_name "$name" | sed 's,mtd,mtdblock,')"
    echo "$mtdblock"
}

NV_MTD=rwfs
NV_MTD_DEV="$(mtd_by_name ${NV_MTD})"
NV_MTD_BLOCKDEV="$(mtdblock_by_name ${NV_MTD})"

nvrw() {
    local p="$1"
    mkdir -p "${RWFS_MNT}${p}" "${RWFS_MNT}${p}.work"
    local mname=$(echo "rwnv${p}" | sed 's,/,,g')
    local opts="lowerdir=${p},upperdir=${RWFS_MNT}${p},workdir=${RWFS_MNT}${p}.work"
    mount -t overlay -o "$opts" "$mname" "$p"
}

targetted_clean() {
    local LOG_TAG="restore-defaults"
    # Do not delete server certificates for the web server or ssh
    echo "removing targetted contents:"
    cd "${RWFS_MNT}/etc"
    for file in *; do
        case $file in
            # The only files that stay are here:
            CA|RestoreDefaultConfiguration|dropbear|sdr|server.pem);;
            # All else get removed.
            *)  echo "remove $file"
                rm -rf $file;;
        esac
    done
    # nothing should be in the workdir, but clear it just in case
    rm -rf "${RWFS_MNT}/etc.work"

    # Log files remaining - but not to stdout.
    echo "Files remaining: $(ls)"

    # clean everything out of /var
    rm -rf "${RWFS_MNT}/var" "${RWFS_MNT}/var.work"
}

full_clean() {
    local OVL=''
    for OVL in $NV_OVERLAYS; do
        rm -rf "${RWFS_MNT}${OVL}" "${RWFS_MNT}${OVL}.work"
    done
}

# check for full factory reset: if so, flash_eraseall $NV_MTD_DEV
bootflags="0x$(sed 's/^.*bootflags=\([0-9a-f]*\).*$/\1/' /proc/cmdline)"
let "restore_op = $bootflags & 0x3"
if [ $restore_op -eq 3 ]; then
    flash_eraseall "$NV_MTD_DEV"
fi

mount -t jffs2 "$NV_MTD_BLOCKDEV" "$RWFS_MNT"

if [ $restore_op -eq 1 ]; then
    targetted_clean
elif [ $restore_op -eq 2 ]; then
    full_clean
fi

for FS in $NV_OVERLAYS; do
    nvrw "$FS"
done

for FS in $TMP_FS; do
    mount -t tmpfs tmpfs "$FS"
done

# make sure that /etc/fw_env.config mirrors our current uboot environment
UENV_MTD_INFO=$(grep UENV /proc/mtd)
if [ -n "$UENV_MTD_INFO" ]; then
    UENV_MTD_INFO=$(echo "$UENV_MTD_INFO" | sed 's,^\([^:]*\): \([0-9a-f]*\) \([0-9a-f]*\) .*,/dev/\1 0 0x\2 0x\3,')
    if ! grep -q "^${UENV_MTD_INFO}$" /etc/fw_env.config; then
        echo "${UENV_MTD_INFO}" > /etc/fw_env.config
        echo "Updated fw_env.config"
    fi
fi

# work around bug where /etc/machine-id will be mounted with a temporary file
# if rootfs is read-only and the file is empty
MACHINE_ID=/etc/machine-id
if [ ! -s "$MACHINE_ID" ]; then
    systemd-machine-id-setup
fi

# mount persistent NV filesystem, where immortal settings live
if ! grep -q sofs /proc/mounts; then
    mkdir -p /var/sofs
    SOFS_MTD=sofs
    SOFS_MTD_BLOCKDEV="$(mtdblock_by_name ${SOFS_MTD})"
    mount -t jffs2 "$SOFS_MTD_BLOCKDEV" /var/sofs
fi

echo "Finished mounting non-volatile overlays"
