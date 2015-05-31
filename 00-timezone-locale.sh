#!/bin/bash
set -e

if [[ -f /etc/locale.gen ]]; then
    grep -F '# zh_CN.UTF-8 UTF-8' /etc/locale.gen && \
        sed -i.zhcn \
            -e '/# zh_CN.UTF-8 UTF-8/czh_CN.UTF-8 UTF-8' \
            -e '/# en_US.UTF-8 UTF-8/cen_US.UTF-8 UTF-8' \
            /etc/locale.gen
fi

locale --all-locales | fgrep zh_CN.utf8 > /dev/null || locale-gen zh_CN.utf8 en_US.UTF-8
