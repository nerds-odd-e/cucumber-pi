#!/bin/bash
set -e

HOSTNAME=odd-pi

echo ${HOSTNAME}.local | tee /etc/hostname

_local_hostname() {
    grep -F "127.0.0.1 ${1}" /etc/hosts || echo "127.0.0.1 ${1}" | tee -a /etc/hosts
}

_local_hostname ${HOSTNAME}
_local_hostname ${HOSTNAME}.local
_local_hostname example.com
_local_hostname atdd
_local_hostname atdd.local

hostname ${HOSTNAME}.local
