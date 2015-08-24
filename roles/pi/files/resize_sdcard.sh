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

## 6399999 - 122880 + 1 = 6277120
## 6277120 * 1.3 + 122880 - 1 = 8283135
## 6277120 * 1.35 + 122880 - 1 = 8596991
## 6277120 * 1.4 + 122880 - 1 = 8910847

touch /var/log/resize2fs_start

DISK_DEV=mmcblk0
PART_NUM=2
PART_START=122880
PART_END=$(printf "%d" $(expr 6399999 + 627712 '*' 6))

CURRENT_PART_END=$(fdisk -l "/dev/$DISK_DEV" | fgrep "${DISK_DEV}p${PART_NUM}" | awk '{print $3}')

if [[ "$CURRENT_PART_END" -ge "$PART_END" ]]; then
    echo "That's OK! $CURRENT_PART_END >= ${PART_END}!"
    fdisk -l "/dev/${DISK_DEV}" | grep -F "/dev/${DISK_DEV}p${PART_NUM}" | awk '{print $2, $3}' > /.mmcblk0_resized
    exit 0
fi

set +e
fdisk "/dev/$DISK_DEV" <<EOF
p
d
$PART_NUM
n
p
$PART_NUM
$PART_START
$PART_END
p
w
EOF
set -e

# now set up an init.d script
cat <<\EOF > /etc/init.d/resize2fs_once &&
#!/bin/sh
### BEGIN INIT INFO
# Provides:          resize2fs_once
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5 S
# Default-Stop:
# Short-Description: Resize the root filesystem to fill partition
# Description:
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
  start)
    log_daemon_msg "Starting resize2fs_once" &&
    resize2fs /dev/root &&
    rm /etc/init.d/resize2fs_once &&
    update-rc.d resize2fs_once remove &&
    log_end_msg $?
    touch /var/log/resize2fs_end
    echo "$PART_START $PART_END" > /.mmcblk0_resized
    ;;
  *)
    echo "Usage: $0 start" >&2
    exit 3
    ;;
esac
EOF

chmod +x /etc/init.d/resize2fs_once &&
update-rc.d resize2fs_once defaults &&

/sbin/reboot
