#!/bin/bash
set -e

command -v javac || apt-get install -y openjdk-7-jdk

case $(uname -m) in
    i386|i686)
        JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386
        ;;
    x86_64)
        JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
        ;;
    armv7l)
        JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm-vfp-hflt
        ;;
    *)
        echo Unknown $(uname -m)
        exit 6
        ;;
esac

cat > /etc/profile.d/java.sh <<EOF
export JAVA_HOME=$JAVA_HOME
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
