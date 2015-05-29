#!/bin/bash
set -e

locale --all-locales | fgrep zh_CN.utf8 > /dev/null || locale-gen zh_CN.utf8
