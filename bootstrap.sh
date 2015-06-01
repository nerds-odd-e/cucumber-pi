#!/bin/bash
set -e

cd "$(dirname $0)"
[[ -z "$SCRIPT_PWD" ]] && SCRIPT_PWD="$(pwd)"

for SC in ??-*.sh; do
    echo "Executing $SC ..."
    sudo bash -e "$SCRIPT_PWD/$SC"
done
