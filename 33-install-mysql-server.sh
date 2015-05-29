#!/bin/bash
set -e

echo "Install MySQL ..."

LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get --force-yes -y install mysql-server

if [[ ! -f /etc/mysql/my.cnf.orig ]]; then
  sed -i.orig "/bind-address/cbind-address = 0.0.0.0" /etc/mysql/my.cnf
  service mysql restart
fi
