#!/bin/bash
set -e

cd $(dirname $0)
for SC in ??-*.sh; do
    echo "Executing $SC ..."
    sudo bash -e "$SC"
done
