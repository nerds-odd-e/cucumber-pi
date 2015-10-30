#!/bin/bash
set -e

echo "Install Android SDK ..."

ANDROID_HOME="${1:-/opt/android-sdk-linux}"
ANDROID_SDK_VERSION="${2:-24.4.1}"

ANDROID_SDK_FILENAME="android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz"

ANDROID_SDK_URL=http://dl.google.com/android/$ANDROID_SDK_FILENAME

ANDROID_PROFILE_FILENAME=/etc/profile.d/android.sh

[[ "i686" == $(uname -i) ]] || apt-get install -y libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1

[[ -d "${ANDROID_HOME}" ]] && rm -r "${ANDROID_HOME}"
curl --silent "$ANDROID_SDK_URL" | tar -C /opt -zx

chown -R root:root $ANDROID_HOME
find $ANDROID_HOME -exec chmod go+r {} \;
find $ANDROID_HOME -type d -exec chmod go+x {} \;
find $ANDROID_HOME -type f -executable -exec chmod go+x {} \;

date > "${ANDROID_HOME}/.sdk-${ANDROID_SDK_VERSION}"
