#!/bin/bash
set -e

echo "Adding Odd-e Wi-Fi configration ..."

grep -E '^\s+ssid="Odd-e_pi_nomap"' /etc/wpa_supplicant/wpa_supplicant.conf ||
    cat > /etc/wpa_supplicant/wpa_supplicant.conf <<EOF

network={
        ssid="Odd-e_pi_nomap"
        psk="raspberrypi"
        proto=RSN
        key_mgmt=WPA-PSK
        pairwise=TKIP
        auth_alg=OPEN
}
EOF
