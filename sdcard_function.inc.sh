#!/usr/bin/env bash
typeset -a DISK_LIST_READONLY

function get_disk_list() {
    diskutil list "$@" | grep -Eo "^/dev/disk[0-9]+"
}

function contains() {
    local -a _ARRAY=("${!1}")
    local _ELEMENT="$2"
    for _e in "${_ARRAY[@]}"; do
        [[ ! "$_e" == "$_ELEMENT" ]] || return 0
    done
    return 1
}

DISK_LIST_READONLY=( $(get_disk_list) )
contains DISK_LIST_READONLY[@] /dev/disk0
contains DISK_LIST_READONLY[@] /dev/disk1 || true

function find_sdcard() {
    local -a _DISKS=( $(get_disk_list physical) )
    for _D in "${_DISKS[@]}"; do
        if ! contains DISK_LIST_READONLY[@] "$_D"; then
            echo "$_D"
            return 0
        fi
    done
    return 1
}

function run() {
    FUN="$1"
    if [[ ! 'function' = "$(type -t "$FUN")" ]]; then
        echo "$FUN is not a function, exit now."
        exit 2
    fi
    echo "Will skip these disks: ${DISK_LIST_READONLY[*]}"
    while true; do
        echo -n "Insert a new SD card, and will find it automaticly. Press enter key to exit."$'\r'
        declare SDCARD
        SDCARD="$(find_sdcard || true)"
        if test -z "$SDCARD"; then
            read -t 2 -r && exit 0
            continue
        fi

        echo -e "\n\nFound a SD card $SDCARD\n"

        [[ "$SDCARD" == /dev/disk[2-9] ]]

        eval "$@"

        diskutil eject "$SDCARD"

        echo "SD card $SDCARD has been rejected."
        echo "Replace a new SD card now."
        echo ""
    done
}
