#!/bin/bash
set -e

## $ sudo fdisk /dev/mmcblk0
##
## Command (m for help): p
##
## Disk /dev/mmcblk0: 7948 MB, 7948206080 bytes
## 4 heads, 16 sectors/track, 242560 cylinders, total 15523840 sectors
## Units = sectors of 1 * 512 = 512 bytes
## Sector size (logical/physical): 512 bytes / 512 bytes
## I/O size (minimum/optimal): 512 bytes / 512 bytes
## Disk identifier: 0xa6202af7
##
##         Device Boot      Start         End      Blocks   Id  System
## /dev/mmcblk0p1            8192      122879       57344    c  W95 FAT32 (LBA)
## /dev/mmcblk0p2          122880     6399999     3138560   83  Linux

PARTITION_ID=2
SEC_START=122880
SEC_END=8160256

RESIZED_FLAG="/.mmcblk0_resized_${PARTITION_ID}_${SEC_START}_${SEC_END}"
resize_mmcblk0_and_reboot() {
    set +e
    fdisk /dev/mmcblk0 <<EOF
d
$PARTITION_ID
n
p
$PARTITION_ID
$SEC_START
$SEC_END
w
EOF
    set -e
    cd "$(dirname "$0")"
    sed -i -e '/^exit 0$/d' /etc/rc.local
    cat >> /etc/rc.local <<EOF
echo cucumber-pi step1; cd "$(pwd)"; nohup bash ./bootstrap.sh >/dev/null & || true
exit 0
EOF
    touch /.mmcblk0_resized_step1
    reboot
}

if [[ ! -e "$RESIZED_FLAG" ]]; then
    if [[ -e /.mmcblk0_resized_step1 ]]; then
        resize2fs "/dev/mmcblk0p${PARTITION_ID}"
        rm /.mmcblk0_resized_step1
        touch "$RESIZED_FLAG"
        reboot
        exit 1
    else
        resize_mmcblk0_and_reboot
        exit 255
    fi
fi

sed -i -e '/^echo cucumber-pi/d' /etc/rc.local

exit 254
