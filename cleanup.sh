#!/bin/bash
set -e

rm -f /root/.bash_history
rm -f /home/*/.bash_history

apt-get -y autoremove
apt-get clean
rm -rf /var/lib/apt/lists/

echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*
