#!/bin/bash
set -e

HOSTNAME="${1:-odd-pi}"

change_hostname() {
  NEW_HOSTNAME="$1"
  LOCAL_DOMAIN=local
  echo $NEW_HOSTNAME > /etc/hostname
  sed -i -e "/^127\\.0\\.1\\.1/c127.0.1.1\t${NEW_HOSTNAME} ${NEW_HOSTNAME}.${LOCAL_DOMAIN}" /etc/hosts
  hostname "${HOSTNAME}.${LOCAL_DOMAIN}"
}

change_hostname "$HOSTNAME"
