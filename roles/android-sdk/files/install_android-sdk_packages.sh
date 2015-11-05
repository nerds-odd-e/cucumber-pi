#!/bin/bash
set -e

ANDROID_HOME="${1:-/opt/android-sdk-linux}"
ANDROID_SDK_PACKAGES="${2:-tools,platform-tools,build-tools-21.1.1,android-21,build-tools-19.1.0,android-19,extra-android-m2repository,extra-android-support,extra-google-m2repository}"

ANDROID_PROFILE_FILENAME=/etc/profile.d/android.sh

echo "Install Android SDK Packages ..."

apt-get install -y expect
expect -i <<EOF
set timeout -1   ;

spawn $ANDROID_HOME/tools/android --silent update sdk --no-ui --all --filter "${ANDROID_SDK_PACKAGES}"

expect {
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
}
EOF

# run adb command as root
chmod +s "$ANDROID_HOME/platform-tools/adb"

cat > "$ANDROID_PROFILE_FILENAME" <<EOF
export ANDROID_HOME=$ANDROID_HOME
export PATH=\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools:\$PATH

alias android-save-packages='tar -C $ANDROID_HOME -zcf $ANDROID_SDK_LOCAL_CACHE build-tools/ extras/ platforms platform-tools/'

[[ -d /home/vagrant/.android ]] && sudo chown -R vagrant:vagrant /home/vagrant/.android
EOF

date > "${ANDROID_HOME}/.sdk-packages"
