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

function skip_disk() {
    for _DISK in "$@"; do
        DISK_LIST_READONLY+=( $_DISK )
    done
    echo "Will skip these disks: ${DISK_LIST_READONLY[*]}"
    echo "Any disk with a capacity of less than 32G will be treated as an SD card."
}

DISK_LIST_READONLY=( $(get_disk_list physical) )
contains DISK_LIST_READONLY[@] /dev/disk0

skip_disk /dev/disk1 >/dev/null
contains DISK_LIST_READONLY[@] /dev/disk1

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
    skip_disk
    while true; do
        echo -n $'\r'"Insert a new SD card, and will find it automaticly. Press enter key to exit."
        declare SDCARD
        SDCARD="$(find_sdcard || true)"
        if test -z "$SDCARD"; then
            read -t 2 -r && exit 0
            continue
        fi

        echo -e "\n\nFound a SD card $SDCARD\n"

        [[ "$SDCARD" == /dev/disk[2-9] ]]

        if eval "$@"; then
            diskutil eject "$SDCARD"

            echo "SD card $SDCARD has been rejected."
            echo "Replace a new SD card now."
        fi
        echo ""
    done
}
